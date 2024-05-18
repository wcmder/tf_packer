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
  type = map(object({
    nsg_name      = string
    security_rule = map(object({
      name              = string
      priority          = number
      direction         = string # Inbound or Outbound
      access            = string # Allow or Deny
      protocol          = string # *, TCP, UDP, ICMP ....
      src_port_range    = optional(string)
      dst_port_range    = optional(string)
      src_port_ranges   = optional(list(string))
      dst_port_ranges   = optional(list(string))
      src_addr_prefix   = optional(string)
      dst_addr_prefix   = optional(string)
      src_addr_prefixes = optional(list(string))
      dst_addr_prefixes = optional(list(string))
      }))
    }))
}
