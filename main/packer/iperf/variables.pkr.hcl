# Azure authentication and build variables.
variable "spn-client-id" {
  type = string
}

variable "spn-client-secret" {
  type      = string
  sensitive = true
}

variable "spn-tenant-id" {
  type = string
}

variable "prod_subscription_id" {
  type    = string
  default = "3ee28fc2-7a0e-46c8-b38d-14ca6a26d742"
}

variable "demo_subscription_id" {
  type    = string
  default = "57cd861e-6e61-4d90-ad57-799cd9f5d1a9"
}

variable "dev_subscription_id" {
  type    = string
  default = "a4b57fa5-2f2c-4732-b452-32be7d1724b1"
}

variable "ubuntu_image_version" {
  type        = string
  description = "Exact Azure Marketplace version of Canonical Ubuntu 22.04 Gen2."
}

variable "iperf_image_version" {
  type        = string
  description = "Immutable Azure Compute Gallery version to publish."

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.iperf_image_version))
    error_message = "The iPerf image version must use numeric major.minor.patch format."
  }
}
