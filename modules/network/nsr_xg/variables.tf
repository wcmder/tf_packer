/*
terraform {
  # Optional attributes and the defaults function are
  # both experimental, so we must opt in to the experiment.
  experiments = [module_variable_optional_attrs]
}
*/

variable "common" {
  type = object ({
    env = string,
    reg = string,
    rsg_name = string,
    rsg_location = string,
    tags = map(any)
  })
}

variable "nsg" {
  type = list(string)
}

variable "name" {
  
}

variable "priority" {
  
}

variable "direction" {
  
}

variable "access" {
  
}

variable "protocol" {
  
}


variable "src_port_range" {
  type = string
  default = null
}

variable "dst_port_range" {
  type = string
  default = null
}


variable "src_port_ranges" {
  type = list(string)
  default = null
}

variable "dst_port_ranges" {
  type = list(string)
  default = null
}



variable "src_addr_prefix" {
  type = string
  default = null
}

variable "dst_addr_prefix" {
  type = string
  default = null
}


variable "src_addr_prefixes" {
  type = list(string)
  default = null
 
}

variable "dst_addr_prefixes" {
  type = list(string)
  default = null

}