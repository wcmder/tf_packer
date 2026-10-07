
variable "vhc" {
  type = map(object({
    #name      = string (use key)
    vnet_id                   = string
    internet_security_enabled = optional(bool)
    routing = optional(map(object({
      a_rtb_id              = optional(string)
      p_rtb_ids             = optional(list(string))
      labels                = optional(list(string))
      inbound_route_map_id  = optional(string)
      outbound_route_map_id = optional(string)
      static_vnet_route = optional(map(object({
        addr_prefixes = list(string)
        next_hop_ip   = string
      })))
      static_vnet_local_route_override_criteria   = optional(string)
      static_vnet_propagate_static_routes_enabled = optional(bool)
    })))


  }))

}


variable "vhub_id" {
  type = string
}
