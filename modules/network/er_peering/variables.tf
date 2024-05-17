
variable "common" {
  type = object({
    env          = string,
    reg          = string,
    rsg_name     = string,
    rsg_location = string,
    tags         = map(any)
  })
}


variable "peering" {
  type = map(object({
    type            = string
    ercc_name       = string
    bgp_key         = string
    peer_bgp_asn    = number
    prim_prefix     = string
    secd_prefix     = string
    vlan            = number
    ipv4_enabled    = bool
    route_filter_id = optional(string)

    microsoft_peering_config = optional(map(object({
      adv_prefix_list        = list(string)
      customer_asn           = optional(number, 0)
      routing_registry_name  = optional(string, "None")
      advertised_communities = optional(list(string))

    })))
  }))
}
