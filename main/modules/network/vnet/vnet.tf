terraform {
  required_version = ">=1.0.2"
}

resource "azurerm_virtual_network" "vnet" {
  for_each            = var.vnet
  name                = join("-", [var.common["env"], each.key])
  resource_group_name = var.common["rsg_name"]
  location            = var.common["reg"]
  # the network summary address in the vnet ["10.0.0.0/16"]
  address_space = each.value[0]
  dns_servers   = each.value[1]

  tags = merge(var.common["tags"], { "ResourceType" = "VNet" })

}


output "vnet_name_id" {
  value = tomap(
    { for e in azurerm_virtual_network.vnet : replace(e.name, "/^${var.common["env"]}-/", "") => e.id }
  )
}

output "vnet_name_name" {
  value = tomap(
    { for e in azurerm_virtual_network.vnet : replace(e.name, "/^${var.common["env"]}-/", "") => e.name }
  )
}


output "vnet_name_and_id_map" {
  value = tomap(
    { for e in azurerm_virtual_network.vnet : e.name => e.id }
  )
}

output "vnet_name_list" {
  value = tolist(
    [for e in azurerm_virtual_network.vnet : e.name]
  )
}
