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

variable "iperf_image_version" {
  type        = string
  description = "Exact Azure Compute Gallery image version used by the iPerf VM."

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.iperf_image_version))
    error_message = "The iPerf image version must use numeric major.minor.patch format."
  }
}

variable "image_resource_group_name" {
  type        = string
  description = "Resource group containing the Azure Compute Gallery."
  default     = "dev-use-images-rg"
}
