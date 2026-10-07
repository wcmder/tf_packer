
resource "azurerm_storage_container" "sa_container" {
  name                  = lower(replace(join("-", [var.common["env"], var.name]), "-", ""))
  storage_account_name  = var.sa_name
  container_access_type = var.access_type
}


output "container_id" {
  value = azurerm_storage_container.sa_container.id
}

output "container_name" {
  value = azurerm_storage_container.sa_container.name
}
