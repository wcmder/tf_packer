variable "common" {
  type = object({
    env          = string,
    reg          = string,
    rsg_name     = string,
    rsg_location = string,
    tags         = map(any)
  })
}


variable "nic" {
  type = map(object({
    nic_name       = string
    auxiliary_mode = optional(string)
    # AcceleratedConnections and Floating
    auxiliary_sku = optional(string)
    # A1, A2, A4 and A8
    dns_server_list         = optional(list(string))
    edge_zone               = optional(string)
    ip_forwarding           = optional(bool)
    accelerated_networking  = optional(bool)
    internal_dns_name_label = optional(string)

    ip_configuration = optional(map(object({
      subnet_id = string
      gwlb_frontend_ip_configu_id = optional(string)
      version                     = optional(string, "IPv4")
      mode                        = optional(string, "Dynamic")
      # Dynamic and Static.
      public_ip_addr_id           = optional(string)
      primary                     = optional(bool, false)
      # Must be true for the first ip_configuration when multiple are specified.

    })))

  }))
}


