resource "azurerm_resource_group" "rsg" {
  for_each = var.rsg
  name     = join("-", [var.common.env, each.key])
  location = each.value.rsg_location

  tags = var.common.tags

}

output "rsg_name_name" {
  value = tomap(
    { for k, e in azurerm_resource_group.rsg : k => e.name }
  )
}

output "rsg_name_location" {
  value = tomap(
    { for k, e in azurerm_resource_group.rsg : k => e.location }
  )
}
