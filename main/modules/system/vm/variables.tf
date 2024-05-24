variable "vm_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "nic_name" {
  type = string
}

variable "ip_name" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "publisher" {
  type    = string
  default = null
}

variable "offer" {
  type    = string
  default = null
}

variable "sku" {
  type    = string
  default = null
}

variable "version" {
  type    = string
  default = null
}

variable "src_img_id" {
  type    = string
  default = null
}

variable "public_ip_addr_id" {
  type = string
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
