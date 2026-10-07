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
  type = string
}

variable "vwan_id" {
  type = string
}

variable "vhub_ipaddr" {
  type = string
}

variable "route_pref" {
  type    = string
  default = "ASPath"
}

variable "sku" {
  type    = string
  default = "Standard"
}
