variable "common" {
  type = object({
    env          = string,
    reg          = string,
    rsg_name     = string,
    rsg_location = string,
    tags         = map(any)
  })
}


variable "vnet_name_id_map" {

}

variable "vnet_name_list" {

}


variable "allow_virtual_network_access" {
  type = bool
  default = true
}

variable "allow_forwarded_traffic" {
  type = bool
  default = true
}

variable "allow_gateway_transit" {
  type = bool
  default = false
}

variable "use_remote_gateways" {
  type = bool
  default = false
}