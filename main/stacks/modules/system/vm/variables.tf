variable "vm_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "nic_name" {
  type = string
}

variable "ip_name" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "caching" {
  type    = string
  default = "ReadWrite"
}

variable "os_disk_size_gb" {
  type        = number
  description = "Optional OS disk size in GB; null uses the source image size."
  default     = null
}

variable "storage_account_type" {
  type    = string
  default = "Standard_LRS"
}

variable "private_ip_address" {
  type        = string
  description = "Optional static private IP address for the VM network interface."
  default     = null
}

variable "ip_forwarding_enabled" {
  type        = bool
  description = "Enable IP forwarding on the VM network interface."
  default     = false
}

variable "accelerated_networking_enabled" {
  type        = bool
  description = "Enable accelerated networking on the VM network interface. Requires a supported VM size and image."
  default     = false
}

variable "publisher" {
  type    = string
  default = null
}

variable "offer" {
  type    = string
  default = null
}

variable "sku" {
  type    = string
  default = null
}

variable "ver" {
  type    = string
  default = null
}

variable "src_img_id" {
  type    = string
  default = null
}

variable "pip_addr_id" {
  type    = string
  default = null
}


variable "common" {
  type = object({
    env          = string,
    reg          = string,
    rsg_name     = string,
    rsg_location = string,
    tags         = map(any)
  })
}

variable "admin_username" {
  type        = string
  description = "Administrator username supplied by the caller."
}

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "Administrator password supplied securely by the caller; stored in Terraform state."
}
