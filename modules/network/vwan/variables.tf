variable "vwan_name" {

}

variable "vpn_encryption" {
  type    = bool
  default = false

}

variable "b_to_b" {
  type    = bool
  default = true
}

variable "o365_out" {
  default = "None"
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
