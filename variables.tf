variable "location" {
    type = string
    description = "Azure resources location"
}

variable "friendly_prefix" {
    type = string
    description = "Friendly prefix prepending to the resource names"
}

variable "admin_permitted_object_ids" {
    type = list(string)
    description = "List of additional Object Ids to be granted with all permissions, the object Id of the current configuration is always added."
}

variable "read_permitted_object_ids" {
    type = list(string)
    default = []
    description = "List of additional Object Ids to be granted with read-only permissions."
}
