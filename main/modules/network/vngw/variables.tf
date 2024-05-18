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

variable "sku" {
  default = "VpnGw1"

}


variable "generation" {
  default = "None"
}