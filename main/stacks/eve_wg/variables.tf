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

variable "vm_size" {
  type        = string
  description = "Nested-virtualization-capable, SCSI-compatible EVE-NG VM size."
  default     = "Standard_E8ds_v5"
  #default = "Standard_D32ds_v5"
}

variable "wireguard_port" {
  type        = number
  description = "Public UDP port on which WireGuard listens."
  default     = 51820

  validation {
    condition     = var.wireguard_port >= 1 && var.wireguard_port <= 65535
    error_message = "The WireGuard port must be between 1 and 65535."
  }
}

variable "wireguard_client_cidr" {
  type        = string
  description = "Address pool assigned to remote WireGuard clients."
  default     = "172.16.0.0/24"

  validation {
    condition     = can(cidrhost(var.wireguard_client_cidr, 0))
    error_message = "The WireGuard client address pool must be a valid CIDR."
  }
}

variable "wireguard_server_address" {
  type        = string
  description = "WireGuard interface address on the EVE-NG server."
  default     = "172.16.0.1/24"

  validation {
    condition     = can(cidrhost(var.wireguard_server_address, 0))
    error_message = "The WireGuard server address must be a valid CIDR address."
  }
}

variable "wireguard_peers" {
  type = map(object({
    public_key = string
    address    = string
  }))
  description = "WireGuard clients keyed by name. Store only client public keys here."
  default     = {}

  validation {
    condition = alltrue([
      for peer in values(var.wireguard_peers) :
      can(regex("^[A-Za-z0-9+/]{43}=$", peer.public_key)) && can(cidrhost(peer.address, 0))
    ])
    error_message = "Every peer must have a base64 WireGuard public key and a valid CIDR address such as 172.16.0.2/32."
  }
}
