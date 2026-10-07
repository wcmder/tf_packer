variable "common" {
  type = object({
    env          = string,
    reg          = string,
    rsg_name     = string,
    rsg_location = string,
    tags         = map(any)
  })
}

variable "bastion_name" {

}

variable "subnet_id" {

}

variable "pip_id" {

}

variable "sku" {
  default = "Standard"

}

variable "file_copy_enabled" {
  default = true
}

variable "ip_connect_enabled" {
  default = true
}

variable "scale_units" {
  default = 5

}

variable "tunneling_enabled" {
  default = true

}

variable "shareable_link_enabled" {
  default = true

}

