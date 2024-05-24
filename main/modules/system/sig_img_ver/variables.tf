variable "ver" {
  type = string
}

variable "sig_name" {
  type = string
}

variable "img_name" {
  type = string
}

variable "blob_uri" {
  type    = string
  default = null
}

variable "sa_id" {
  type    = string
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
