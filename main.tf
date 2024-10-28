provider "azuread" {

}

/* locals {
    packages       = csvdecode(file("${path.module}/package_data.csv"))
}

resource "package_list" "package {
    for_each = { for package in local.packages }

    
} */

module "accesspackage" {
    source = "./modules/accesspackage"
    catalog_id = "17834343-4a83-4d92-a72d-f6dd34445427"
    name = "Terraform Access Package"
    description = "This is a test access package"
    approver_upns = ["testadmin@4mm84s.onmicrosoft.com"]
    duration = 1
    resource_ids = []
}