
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

variable "cidrs" {
  type = list(string)
}

