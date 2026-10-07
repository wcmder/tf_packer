# last udpate Oct2023

resource "azurerm_express_route_gateway" "ergw" {
  name                          = join("-", [var.common["env"], var.ergw_name])
  resource_group_name           = var.common["rsg_name"]
  location                      = var.common["reg"]
  virtual_hub_id                = var.vhub_id
  scale_units                   = var.scale_units
  allow_non_virtual_wan_traffic = var.none_vwan_traffic

  tags = merge(var.common["tags"], { "ResourceType" = "ExpressRoute Gateway" })

  timeouts {}

}

output "ergw_id" {
  value = azurerm_express_route_gateway.ergw.id
}
