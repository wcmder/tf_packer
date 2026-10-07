
/*
variable "nsg_subnet" {
  type = list(list(string))

}
}
*/

variable "nsg_subnet" {
  type = map(object({
    nsg_id    = string
    subnet_id = string
  }))
}