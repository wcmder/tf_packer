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

variable "vpngw_id" {

}

variable "vpnsite_id" {

}

variable "vpn_link" {
  type = map(object({
    link_name           = string
    link_id             = string
    link_ipsec_key      = string
    enable_bgp          = bool
    policy_based_enable = bool
    ipsec_policy = map(object({
      dh_group         = string
      ike_encryption   = string
      ike_integrity    = string
      ipsec_encryption = string
      ipsec_integrity  = string
      pfs_group        = string
      sa_data_size_kb  = number
      sa_lifetime_sec  = number
    }))
  }))
}


variable "routing" {
  type = map(object({
    associated_route_table = string
    p_route_table_ids      = list(string)
    p_labels               = list(string)
  }))
}


variable "traffic_selector_policy" {
  type = map(object({
    local_addr_ranges  = list(string)
    remote_addr_ranges = list(string)
  }))
}
