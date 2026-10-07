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

variable "gw_pip_addr" {

}

variable "local_prefix_list" {

}

variable "bgp_settings" {
  type = map(object({
    bgp_asn = string
    peer_ip = string
  }))
}