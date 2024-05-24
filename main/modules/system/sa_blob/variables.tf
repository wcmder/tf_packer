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
  type = string
}

variable "sa_name" {
  type = string
}

variable "container_name" {
  type = string
}

variable "type" {
  type    = string
  default = "Block"
}

