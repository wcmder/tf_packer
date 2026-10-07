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

}

variable "act_tier" {
  default = "Standard"
}


variable "act_type" {
  default = "GRS"
}