
variable "resource_ids" {
    type = list(string)
}

variable "catalog_id" {
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

variable "duration" {
    type = number
}