variable "vm_name" {

}
/*variable "rsg_location" {

}

variable "rsg_name" {

}*/

variable "subnet1_id" {

}

variable "nic1_name" {

}

variable "ip1_name" {

}


variable "subnet2_id" {

}

variable "nic2_name" {

}

variable "ip2_name" {

}


variable "subnet3_id" {

}


variable "nic3_name" {

}


variable "ip3_name" {

}


variable "pip1_id" {
  type = string

}

variable "pip2_id" {
  type    = string
  default = null
}


variable "ssd_name" {
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
