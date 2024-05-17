
variable "common" {
  type = object({
    env          = string,
    reg          = string,
    rsg_name     = string,
    rsg_location = string,
    tags         = map(any)
  })
}

variable "prefix_length" {
  type = number

}

variable "name" {
  type = string
}

variable "zones" {
  default = null
}