# last udpate Oct2023

terraform {
  required_version = ">=1.6.2"
}


resource "azurerm_log_analytics_workspace" "la_wks" {
  name                = replace(join("-", [var.common["env"], var.name]), "_", "-")
  location            = var.common["reg"]
  resource_group_name = var.common["rsg_name"]
  sku                 = var.sku
  retention_in_days   = var.retention_in_days
  daily_quota_gb      = var.daily_quota_gb
  
  tags                = merge(var.common["tags"], { "ResourceType" = "Log Analytics" })

}

output "la_wks_name" {
  value = azurerm_log_analytics_workspace.la_wks.name

}

output "la_wks_id" {
  value = azurerm_log_analytics_workspace.la_wks.id

}
