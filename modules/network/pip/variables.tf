variable "common" {
  type = object ({
    env = string,
    reg = string,
    rsg_name = string,
    rsg_location = string,
    tags = map(any)
  })
}


variable "pip_name" {
  
}


variable "method" {
  default = "Static"
}


variable "sku" {
  default = "Standard"
}


variable "ipprefix_id" {
  default = null
}

variable "zones" {
  default = null
}


variable "ddos_protection_mode" {
  default = "VirtualNetworkInherited"
}


variable "ddos_protection_plan_id" {
  default = null
}


variable "idle_timeout_in_minutes" {
  default = 4
}


variable "sku_tier" {
  default = "Regional"
}