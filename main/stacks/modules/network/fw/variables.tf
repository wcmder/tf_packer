
variable "fw_name" {

}

variable "fw_policy_id" {

}


variable "dns_server_list" {
  default = null
}


variable "threat_intel_mode" {
  type = string
  # Off, Alert and Deny. Defaults to Alert.
  default = null
}

variable "zone_list" {
  type    = list(string)
  default = null
}

variable "sku_name" {
  type = string
  # AZFW_Hub and AZFW_VNet
  default = "AZFW_VNet"
}


variable "sku_tier" {
  type = string
  # Premium, Standard and Basic.
  default = "Standard"
}

variable "ip_range_list" {
  type    = list(string)
  default = null
}


variable "virtual_hub" {
  type = map(object({
    vhub_id   = string
    pip_count = optional(number, 1)
  }))

  default = null
}


variable "ip_configuration" {
  type = map(object({
    subnet_id            = string
    public_ip_address_id = string
  }))

  default = null
}

variable "management_ip_configuration" {
  type = map(object({
    subnet_id            = string
    public_ip_address_id = string
  }))

  default = null
}


variable "common" {
  type = object({
    env          = string,
    reg          = string,
    rsg_name     = string,
    rsg_location = string,
    tags         = map(any)
  })
}
