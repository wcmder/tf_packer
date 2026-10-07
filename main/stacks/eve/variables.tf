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
  description = "Azure region for EVE-NG resources."
}

variable "service_name" {
  type        = string
  description = "Service suffix used in generated names."
  default     = "lab"
}

variable "resource_group_name" {
  type        = string
  description = "Logical resource-group name."
  default     = "rg"
}

variable "eve_image_version" {
  type        = string
  description = "Exact Azure Compute Gallery image version used by the EVE-NG VM."

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.eve_image_version))
    error_message = "The EVE image version must use numeric major.minor.patch format."
  }
}

variable "image_resource_group_name" {
  type        = string
  description = "Resource group containing the Azure Compute Gallery."
  default     = "dev-use-images-rg"
}

variable "vpn_client_tenant_id" {
  type        = string
  description = "Microsoft Entra tenant ID used to authenticate Point-to-Site VPN clients."
}

variable "vm_admin_username" {
  type        = string
  description = "VM administrator username supplied by the deployment pipeline."
}

variable "vm_admin_password" {
  type        = string
  sensitive   = true
  description = "VM administrator password supplied by a secret pipeline variable; stored in Terraform state."
}
