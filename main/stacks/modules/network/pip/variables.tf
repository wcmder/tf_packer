variable "common" {
  type = object({
    env          = string,
    reg          = string,
    rsg_name     = string,
    rsg_location = string,
    tags         = map(any)
  })
}

variable "pip" {
  type = map(object({
    method                  = optional(string, "Static")
    sku                     = optional(string, "Standard")
    ipprefix_id             = optional(string)
    zones                   = optional(list(string))
    ddos_protection_mode    = optional(string, "VirtualNetworkInherited")
    ddos_protection_plan_id = optional(string)
    idle_timeout_in_minutes = optional(number, 4)
    sku_tier                = optional(string, "Regional")
  }))
  default = {}
}
