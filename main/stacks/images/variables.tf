variable "environment" {
  type        = string
  description = "Environment name used for naming and tags."
}

variable "location" {
  type        = string
  description = "Azure region containing the gallery."
}

variable "service_name" {
  type        = string
  description = "Service suffix used in generated names."
}

variable "resource_group_name" {
  type        = string
  description = "Logical name of the resource group created for images."
}
