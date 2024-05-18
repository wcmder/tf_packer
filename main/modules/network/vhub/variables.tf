variable "common" {
  type = object({
    env          = string,
    reg          = string,
    rsg_name     = string,
    rsg_location = string,
    tags         = map(any)
  })
}

variable "vhub_name" {

}

variable "vwan_id" {

}

variable "vhub_ipaddr" {

}

variable "route_pref" {
  default = "ExpressRoute"
}

variable "sku" {
  default = "Standard"
}
