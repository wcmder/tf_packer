# last udpate Nov2023

terraform {
  required_version = ">=1.6.2"
}



resource "azurerm_public_ip" "pip" {
  name                = var.pip_name
  resource_group_name = var.common["rsg_name"]
  location            = var.common["reg"]
  allocation_method   = var.method
  sku                 = var.sku
  zones               = var.zones
  public_ip_prefix_id = var.ipprefix_id

  tags = merge(var.common["tags"], { "ResourceType" = "Public IP" })

}

output "pip_ip" {
  value = azurerm_public_ip.pip.ip_address
}


output "pip_id" {
  value = azurerm_public_ip.pip.id
}
