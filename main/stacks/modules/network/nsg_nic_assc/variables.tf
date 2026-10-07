
/*
variable "nsg_subnet" {
  type = list(list(string))

}
}
*/

variable "nsg_nic" {
  type = map(object({
    nsg_id = string
    nic_id = string
  }))
}