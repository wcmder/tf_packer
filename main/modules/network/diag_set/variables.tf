
variable "common" {
  type = object({
    env          = string,
    reg          = string,
    rsg_name     = string,
    rsg_location = string,
    tags         = map(any)
  })
}

# retention policy is now handled by azurerm_storage_management_policy
variable "enabled_log" {
  type = map(object({
    log_cat     = optional(string),
    log_cat_grp = optional(string),
  }))
}

# retention policy is now handled by azurerm_storage_management_policy
variable "metric" {
  type = map(object({
    metric_cat = string,
  }))
}


variable "name" {

}

variable "target_id" {

}


variable "sa_id" {

}


variable "eh_name" {
  default = null
}


variable "eh_autho_rule_id" {
  description = "namespace authorization rule id"
  default = null
}


variable "partner_solution_id" {
  default = null
}


variable "la_wks_id" {

}


variable "log_analytics_destination_type" {
  type    = string
  default = "Dedicated"
  # AzureDiagnostics (legacy) and Dedicated (same as Resource Specific in MS Doc)
}

