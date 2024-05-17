terraform {
  required_version = ">=1.0.2"
}

resource "azurerm_resource_group" "rsg" {
  for_each = var.main == true ? var.rsg : {}
  name     = join("-", [var.env, each.value.rsg_name])
  location = each.value.rsg_location

  tags = var.common
  
}

/*
output "rsg_name" {
    value = azurerm_resource_group.rsg[0].name
  
}

output "rsg_location" {
    value = azurerm_resource_group.rsg[0].location
  
}
*/

output "rsg_name_name" {
  value = tomap(
    { for e in azurerm_resource_group.rsg : replace(e.name, "/^${var.env}-/", "") => e.name}
  )
}

output "rsg_name_location" {
  value = tomap(
    { for e in azurerm_resource_group.rsg : replace(e.name, "/^${var.env}-/", "") => e.location}
  )
}