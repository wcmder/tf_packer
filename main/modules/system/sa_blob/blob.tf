
resource "azurerm_storage_blob" "sa_blob" {
  name                   = lower(replace(join("-", [var.common["env"], var.name]), "-", ""))
  storage_account_name   = var.sa_name
  storage_container_name = var.container_name
  type                   = var.type
  #size                   = var.size
}


output "blob_id" {
  value = azurerm_storage_blob.sa_blob.id
}


output "blob_url" {
  value = azurerm_storage_blob.sa_blob.url
}
