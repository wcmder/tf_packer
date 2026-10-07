variable "name" {
  type    = string
  default = null
}

variable "vhub_id" {
  type    = string
  default = null
}

variable "routing_policy" {
  type = map(object({
    destinations = list(string)
    next_hop     = string
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
