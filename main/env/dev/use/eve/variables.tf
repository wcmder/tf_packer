variable "spn-client-id" {
  type        = string
  description = "Azure service-principal client ID."
}

variable "spn-client-secret" {
  type        = string
  description = "Azure service-principal client secret."
  sensitive   = true
}

variable "spn-tenant-id" {
  type        = string
  description = "Azure tenant ID."
}

variable "dev_subscription_id" {
  type        = string
  description = "Azure subscription that hosts the development EVE-NG environment."
  default     = "a4b57fa5-2f2c-4732-b452-32be7d1724b1"
}

variable "eve_image_version" {
  type        = string
  description = "Exact Azure Compute Gallery image version used by the EVE-NG VM."
}
