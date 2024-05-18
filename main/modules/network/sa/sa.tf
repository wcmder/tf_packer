resource "azurerm_storage_account" "sa" {
  name               = lower(replace(join("-", [var.common["env"], var.name]), "-", ""))
  resource_group_name = var.common["rsg_name"]
  location            = var.common["reg"]
  account_tier             = var.act_tier
  account_replication_type = var.act_type

  tags = merge(var.common["tags"], {"ResourceType" = "Storage Account"})

}

output "sa_id" {
    value = azurerm_storage_account.sa.id
  
}