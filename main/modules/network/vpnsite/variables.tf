variable "common" {
  type = object ({
    env = string,
    reg = string,
    rsg_name = string,
    rsg_location = string,
    tags = map(any)
  })
}


variable "name" {

}

variable "vwan_id" {

}


variable "site_prefix_list" {
  type = list(string)
  default = null
}


variable "link" {
  type = map(object({
    link_name = string
    remote_ip = string
    bgp = map(object({
      bgp_asn = string
      peer_ip = string
    }))
  }))
}