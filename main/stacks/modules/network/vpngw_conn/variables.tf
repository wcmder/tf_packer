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
  type = string
}

variable "vpngw_id" {
  type = string
}

variable "vpnsite_id" {
  type = string
}

variable "internet_security_enabled" {
  type    = bool
  default = false
}

variable "vpn_link" {
  type = map(object({
    #link_name           = string (use key)
    link_id             = string
    link_ipsec_key      = string
    protocol            = string
    enable_bgp          = bool
    policy_based_enable = optional(bool)
    bandwidth_mbps      = optional(number)
    ipsec_policy = optional(map(object({
      dh_group         = string
      ike_encryption   = string
      ike_integrity    = string
      ipsec_encryption = string
      ipsec_integrity  = string
      pfs_group        = optional(string)
      sa_data_size_kb  = optional(number)
      sa_lifetime_sec  = optional(number)
    })))
  }))
}


variable "routing" {
  type = map(object({
    associated_route_table = string
    p_route_table_ids      = optional(list(string))
    p_labels               = optional(list(string))
    inbound_route_map_id   = optional(string)
    outbound_route_map_id  = optional(string)
  }))
  default = null
}


variable "traffic_selector_policy" {
  type = map(object({
    local_addr_ranges  = list(string)
    remote_addr_ranges = list(string)
  }))
  default = null
}
