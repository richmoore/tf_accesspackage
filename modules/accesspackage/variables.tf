
variable "resource_groups" {
    type = list(string)
}

variable "catalog_name" {
    type = string
}

variable "name" {
    type = string
}

variable "description" {
    type = string
}

variable "approver_upns" {
    type = list(string)
}

variable "approver_groups" {
    type = list(string)
}

variable "duration" {
    type = number
}