data "azuread_user" "approver_users" {
    for_each = toset(var.approver_upns)
    user_principal_name = each.value
}

data "azuread_group" "approver_groups" {
    for_each = toset(var.approver_groups)
    display_name = each.value
}

data "azuread_group" "resource_groups" {
    for_each = toset(var.resource_groups)
    display_name = each.value
}

data "azuread_access_package_catalog" "catalog" {
    display_name = var.catalog_name
}

locals {
   approver_ids = [for user in data.azuread_user.approver_users : user.object_id] 
   approver_group_ids = [for group in data.azuread_group.approver_groups : group.object_id] 
   resource_group_ids = [for group in data.azuread_group.resource_groups : group.object_id] 
}

resource "azuread_access_package" "access_package" {
    catalog_id = data.azuread_access_package_catalog.catalog.id
    description = var.description
    display_name = var.name
    hidden = false
}

resource "azuread_access_package_resource_catalog_association" "resource_catalog_association" {
    for_each = toset(local.resource_group_ids)
    catalog_id             = data.azuread_access_package_catalog.catalog.id
    resource_origin_id     = each.key
    resource_origin_system = "AadGroup"
}

resource "azuread_access_package_resource_package_association" "example" {
    for_each = toset(local.resource_group_ids)
    access_package_id               = azuread_access_package.access_package.id
    catalog_resource_association_id = azuread_access_package_resource_catalog_association.resource_catalog_association[each.key].id
}

resource "azuread_access_package_assignment_policy" "access_package_policy" {
    access_package_id = azuread_access_package.access_package.id
    display_name      = "Initial Policy"
    description       = "Initial Policy"
    duration_in_days  = var.duration
    approval_settings {
        approval_required = true
        requestor_justification_required = true

        approval_stage {
            alternative_approval_enabled        = false
            approval_timeout_in_days            = 3
            approver_justification_required     = true
            enable_alternative_approval_in_days = 0

            dynamic "primary_approver" {
                for_each = local.approver_ids

                content {
                    backup       = false
                    object_id    = primary_approver.value
                    subject_type = "SingleUser"
                }
            }

            dynamic "primary_approver" {
                for_each = local.approver_group_ids

                content {
                    backup       = false
                    object_id    = primary_approver.value
                    subject_type = "GroupMembers"
                }
            }
        }
    }
    
    requestor_settings {
        requests_accepted = true
        scope_type = "AllExistingDirectoryMemberUsers"
    }
}
