variable "ver" {
  type = string
}

variable "sig_name" {
  type = string
}

variable "img_name" {
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
