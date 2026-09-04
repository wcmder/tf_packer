variable "environment" {
  type        = string
  description = "Environment name used for naming and tags."

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be dev or prod."
  }
}

variable "location" {
  type        = string
  description = "Azure region for iPerf resources."
}

variable "service_name" {
  type        = string
  description = "Service suffix used in generated names."
  default     = "iperf"
}

variable "resource_group_name" {
  type        = string
  description = "Logical resource-group name."
  default     = "rg"
}
