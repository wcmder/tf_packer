variable "vm_name" {
  
}
/*variable "rsg_location" {
  
}

variable "rsg_name" {
  
}*/

variable "subnet_id" {
  
}

variable "nic_name" {

}

variable "ip_name" {
  
}

variable "common" {
  type = object ({
    env = string,
    reg = string,
    rsg_name = string,
    rsg_location = string,
    tags = map(any)
  })
}
