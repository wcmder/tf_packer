variable "common" {
  type = object({
    env          = string,
    reg          = string,
    rsg_name     = string,
    rsg_location = string,
    tags         = map(any)
  })
}

variable "name" {

}

variable "type" {
  default = "Vpn"

}

variable "vpn_type" {
  default = "RouteBased"

}

variable "active_active" {
  default = false

}

variable "enable_bgp" {
  default = true

}

variable "bgp_settings" {
  type = object({
    bgp_asn = number
  })

  default = null

}


variable "ip_configuration" {
  type = map(object({
    gw_pip_id = string
    method    = string
    subnet_id = string
  }))

}

variable "custom_route" {
  description = "Optional custom routes advertised to VPN clients."
  type = object({
    address_prefixes = optional(list(string), [])
  })
  default = null
}

variable "vpn_client_configuration" {
  description = "Optional point-to-site VPN client configuration."
  type = object({
    address_space         = list(string)
    aad_audience          = optional(string)
    aad_issuer            = optional(string)
    aad_tenant            = optional(string)
    radius_server_address = optional(string)
    radius_server_secret  = optional(string)
    vpn_auth_types        = optional(list(string))
    vpn_client_protocols  = optional(list(string))
    ipsec_policy = optional(object({
      dh_group                  = string
      ike_encryption            = string
      ike_integrity             = string
      ipsec_encryption          = string
      ipsec_integrity           = string
      pfs_group                 = string
      sa_data_size_in_kilobytes = number
      sa_lifetime_in_seconds    = number
    }))
    radius_servers = optional(list(object({
      address = string
      score   = number
      secret  = string
    })), [])
    revoked_certificates = optional(list(object({
      name       = string
      thumbprint = string
    })), [])
    root_certificates = optional(list(object({
      name             = string
      public_cert_data = string
    })), [])
    client_connections = optional(list(object({
      address_prefixes   = list(string)
      name               = string
      policy_group_names = list(string)
    })), [])
  })
  default = null
}

variable "sku" {
  default = "VpnGw3AZ"

}


variable "generation" {
  default = "Generation2"
}
