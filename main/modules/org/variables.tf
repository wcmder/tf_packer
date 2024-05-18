
variable "main" {
    type = bool
  
}

variable "rsg_name" {
  description = "prepended by env at the resource module"
}


variable "rsg_location" {
    description = "region for the resource group"
}

variable "reg" {
    description = "region for the resource be creatd in"
}


variable "svc_name" {
    description = "lab or netowrk or .."
  
}

variable "env" {
    description = "prod or ..."
  
}