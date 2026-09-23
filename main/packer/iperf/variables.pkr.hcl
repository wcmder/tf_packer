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

variable "subscription_id" {
  type        = string
  description = "Azure subscription used for the build and destination gallery."
}

variable "image_resource_group" {
  type        = string
  description = "Resource group containing the destination gallery."
}

variable "gallery_name" {
  type        = string
  description = "Existing Azure Compute Gallery to publish into."
}

variable "location" {
  type        = string
  description = "Azure region for the build and image replication."
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
