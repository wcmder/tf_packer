/*
terraform {
  # Optional attributes and the defaults function are
  # both experimental, so we must opt in to the experiment.
  experiments = [module_variable_optional_attrs]
}
*/


variable "common" {
  type = object({
    env          = string,
    reg          = string,
    rsg_name     = string,
    rsg_location = string,
    tags         = map(any)
  })
}


variable "rtb" {
  type = map(object({
    vnet_name = optional(string)
    #name                          = string
    bgp_route_propagation_enabled = optional(bool)
    route = optional(map(object({
      #name          = string
      prefix        = string
      next_hop_type = string
      next_hop_ip   = optional(string)
    })))
  }))
}

