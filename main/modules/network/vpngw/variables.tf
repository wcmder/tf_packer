variable "common" {
  type = object ({
    env = string,
    reg = string,
    rsg_name = string,
    rsg_location = string,
    tags = map(any)
  })
}


variable "vhub_id" {
  
}

variable "name" {
  
}

variable "scale_unit" {
  default = 1
}