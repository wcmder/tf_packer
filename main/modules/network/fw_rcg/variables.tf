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

variable "fw_policy_id" {
  type = string
}

variable "priority" {
  type = number
}

variable "fw_rcg_name" {
  type = string
}


variable "network_rule_collection" {
  type = map(object({
    name     = string
    priority = number
    action   = string

    rule = map(object({
      src_addr_list  = optional(list(string))
      src_ipgrp_list = optional(list(string))
      dst_addr_list  = optional(list(string))
      dst_ipgrp_list = optional(list(string))
      dst_port_list  = list(string)
      protocol_list  = list(string)
      dst_fqdn_list  = optional(list(string))
    }))
  }))

  default = null

}


variable "application_rule_collection" {
  type = map(object({
    name     = string
    priority = number
    action   = string

    rule = map(object({
      description       = optional(string)
      src_addr_list     = optional(list(string))
      src_ipgrp_list    = optional(list(string))
      dst_addr_list     = optional(list(string))
      dst_url_list      = optional(list(string))  # Premium SKU
      dst_fqdn_list     = optional(list(string))
      dst_fqdn_tag_list = optional(list(string))
      terminate_tls     = optional(bool)          # Premium SKU
      web_category_list = optional(list(string))  # Premium SKU

      protocols = map(object({
        type = string
        port = number
      }))

    }))

  }))

  default = null

}