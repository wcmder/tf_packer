
variable "vhc" {
  type = map(object({
    name      = string
    vnet_id   = string
    a_rtb_id  = string
    p_rtb_ids = list(string)
    labels    = list(string)
    static_vnet_route = map(object({
      addr_prefixes = list(string)
      next_hop_ip   = string
    }))

  }))

}


variable "vhub_id" {

}
