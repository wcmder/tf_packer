variable "common" {
  type = object({
    env          = string,
    reg          = string,
    rsg_name     = string,
    rsg_location = string,
    tags         = map(any)
  })
}


variable "vnet_remote" {
  type = map(object({
    vnet_remote_id = string
    peering_name = string
  }))
}


variable "allow_virtual_network_access" {
  type = bool
}

variable "allow_forwarded_traffic" {
  type = bool
}

variable "allow_gateway_transit" {
  type = bool
}

variable "use_remote_gateways" {
  type = bool
}


variable "vnet_local_name" {

}

variable "vnpeer_do" {
  type = bool
}
