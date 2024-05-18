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
  default = "IPsec"

}


variable "ercircuit_id" {
  default = null
}

variable "vngw_id" {

}

variable "lng_id" {
  default = null
}

variable "ike" {
  default = null

}

variable "ipsec_key" {
  default = null
}

variable "enable_bgp" {
  default = true
}

variable "azure_ip" {
  default = false
}


variable "ipsec_policy" {
  type = object({
    dh_group         = string
    ike_encryption   = string
    ike_integrity    = string
    ipsec_encryption = string
    ipsec_integrity  = string
    pfs_group        = string
    sa_data_size_kb  = number
    sa_lifetime_sec  = number
  })

  default = null

}
