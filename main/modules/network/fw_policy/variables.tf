

variable "common" {
  type = object({
    env          = string,
    reg          = string,
    rsg_name     = string,
    rsg_location = string,
    tags         = map(any)
  })
}

variable "fw_policy_name" {

}

variable "sku" {
  # Standard, Premium and Basic. 
  default = "Standard"

}

variable "parent_policy_id" {

  default = null
}

variable "auto_learn_private_ips" {
  type    = bool
  default = false
}

variable "threat_intel_mode" {
  # Alert, Deny and Off. Defaults to Alert.
  default = "Alert"
}

variable "sql_redirect" {
  type    = bool
  default = false
}


variable "dns" {
  type = map(object({
    enabled = bool
    servers = list(string)
  }))

  default = null

}

variable "insights" {
  type = map(object({
    enabled           = bool
    default_la_wks_id = string
    retention_days    = optional(number, 90)

    log_analytics_workspace = optional(map(object({
      la_wks_id   = string
      fw_location = string
    })))

  }))

  default = null

}


variable "intrusion_detection" {
  type = map(object({
    # Off, Alert or Deny.
    mode           = optional(string)
    private_ranges = optional(list(string))

    signature_overrides = optional(map(object({
      signature_id = optional(string)
      # Off, Alert or Deny.
      state = optional(string)
    })))

    traffic_bypass = optional(map(object({
      name = string
      # ANY, TCP, ICMP, UDP
      protocol        = string
      description     = string
      dst_addr_list   = optional(list(string))
      dst_ip_grp_list = optional(list(string))
      dst_port_list   = optional(list(string))
      src_addr_list   = optional(list(string))
      src_ip_grp_list = optional(list(string))
    })))

  }))

  default = null

}


variable "threat_intelligence_allowlist" {
  type = map(object({
    fqdn_list    = optional(list(string))
    ip_addr_list = optional(list(string))
  }))

  default = null

}


variable "tls_certificate" {
  type = map(object({
    name         = string
    kv_secret_id = string
  }))

  default = null

}


variable "explicit_proxy" {
  type = map(object({
    enabled         = optional(bool)
    http_port       = optional(string)
    https_port      = optional(string)
    enable_pac_file = optional(bool)
    pac_file_port   = optional(string)
    pac_file        = optional(string)
  }))

  default = null

}
