variable "env" {
  type        = string
  description = "Environment name, such as dev or prod."
}

variable "reg" {
  type        = string
  description = "Azure region for resources created by the consuming stack."
}

variable "svc_name" {
  type        = string
  description = "Service suffix used in generated resource names."
}
