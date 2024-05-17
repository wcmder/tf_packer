
variable "common" {
  type = object({
    env          = string,
    reg          = string,
    rsg_name     = string,
    rsg_location = string,
    tags         = map(any)
  })
}


variable "ergw_name" {

}

variable "vhub_id" {

}

variable "scale_units" {
  default = 1
}

variable "none_vwan_traffic" {
  type = bool
  default = false
}