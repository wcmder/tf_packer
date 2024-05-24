variable "img_name" {
  type = string
}

variable "img_gallery_name" {
  type = string
}

variable "os_type" {
  type = string
}

variable "publisher" {
  type = string
}

variable "offer" {
  type = string
}

variable "sku" {
  type = string
}

variable "hyper_v_generation" {
  type    = string
  default = "V2"
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
