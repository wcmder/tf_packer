terraform {
  required_version = ">=1.0.2"
}

resource "azurerm_virtual_wan" "vwan" {
  name                              = join("-", [var.common["env"], var.vwan_name])
  resource_group_name               = var.common["rsg_name"]
  location                          = var.common["reg"]
  disable_vpn_encryption            = var.vpn_encryption
  allow_branch_to_branch_traffic    = var.b_to_b
  office365_local_breakout_category = var.o365_out


  tags = merge(var.common["tags"], { "ResourceType" = "vWan" })

}

output "vwan_id" {
  value = azurerm_virtual_wan.vwan.id
}



output "vwan_name" {
  value = azurerm_virtual_wan.vwan.name
}
