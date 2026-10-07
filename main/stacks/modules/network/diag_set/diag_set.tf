# last udpate Oct2023

resource "azurerm_monitor_diagnostic_setting" "diag_set" {
  name                           = join("-", [var.common["env"], var.name])
  target_resource_id             = var.target_id
  storage_account_id             = var.sa_id
  eventhub_name                  = var.eh_name
  eventhub_authorization_rule_id = var.eh_autho_rule_id
  partner_solution_id            = var.partner_solution_id
  log_analytics_workspace_id     = var.la_wks_id
  log_analytics_destination_type = var.log_analytics_destination_type

  dynamic "enabled_log" {
    for_each = var.enabled_log
    content {
      category       = enabled_log.value.log_cat
      category_group = enabled_log.value.log_cat_grp
    }
  }

  dynamic "metric" {
    for_each = var.metric == null ? {} : var.metric
    content {
      category = metric.value.metric_cat
    }
  }
}


output "diag_set_id" {
  value = azurerm_monitor_diagnostic_setting.diag_set.id

}
