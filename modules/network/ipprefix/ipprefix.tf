

resource "azurerm_public_ip_prefix" "ipprefx" {
  name                = join("-", [var.common["env"], var.name])
  location            = var.common["reg"]
  resource_group_name = var.common["rsg_name"]

  prefix_length = var.prefix_length
  zones         = var.zones


  tags = merge(var.common["tags"], { "ResourceType" = "IpPrefix" })
}


output "ipprefix_id" {
  value = azurerm_public_ip_prefix.ipprefx.id
}
