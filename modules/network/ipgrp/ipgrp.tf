


resource "azurerm_ip_group" "ipgrp" {

  name                = join("-", [var.common["env"], var.name])
  location            = var.common["reg"]
  resource_group_name = var.common["rsg_name"]

  cidrs = var.cidrs

  tags = merge(var.common["tags"], { "ResourceType" = "IpGroup" })

}

output "ipgrp_id" {
  value = azurerm_ip_group.ipgrp.id
}