/*
terraform {
  # Optional attributes and the defaults function are
  # both experimental, so we must opt in to the experiment.
  experiments = [module_variable_optional_attrs]
}
*/

variable "subnet" {
  type = map(object({
    cidr = list(string)

    delegation = optional(map(object({
      name = string

      service_delegation = map(object({
        name    = string
        actions = optional(list(string))
      }))

    })))

    private_endpoint_policy     = optional(bool)
    private_link_policy         = optional(bool)
    service_endpoints           = optional(list(string))
    service_endpoint_policy_ids = optional(list(string))

  }))

  #subnets = { for x, y in {"net1":"10.1.1.0/26", "net2":"10.1.1.64/26"} : x => y }
}

/*
variable "delegation_name" {
  type = string
}


variable "servie_delegation" {
  type = object ({
    name = string
    actions = optional(list(string))
  })
}
*/

/*variable "rsg_name" {
  
}*/

variable "vnet_name" {

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
