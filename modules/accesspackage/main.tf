
resource "azuread_access_package" "access_package" {
    catalog_id = var.catalog_id
    description = var.description
    display_name = var.name
    hidden = false
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
                for_each = var.approver_ids

                content {
                    backup       = false
                    object_id    = primary_approver.value
                    subject_type = "SingleUser"
                }
            }
        }
    }
    
    requestor_settings {
        requests_accepted = true
        scope_type = "AllExistingDirectoryMemberUsers"
    }
}
