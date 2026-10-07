
resource "azurerm_virtual_hub" "vhub" {
  name                   = join("-", [var.common["env"], var.vhub_name])
  resource_group_name    = var.common["rsg_name"]
  location               = var.common["reg"]
  virtual_wan_id         = var.vwan_id
  address_prefix         = var.vhub_ipaddr
  hub_routing_preference = var.route_pref
  sku                    = var.sku

  tags = merge(var.common["tags"], { "ResourceType" = "Virtual Hub" })

}

output "vhub_id" {
  value = azurerm_virtual_hub.vhub.id
}

output "vhub_name" {
  value = azurerm_virtual_hub.vhub.name
}

output "vhub_default_rt_id" {
  value = azurerm_virtual_hub.vhub.default_route_table_id
}

output "vhub_bgp_asn" {
  value = azurerm_virtual_hub.vhub.virtual_router_asn
}

output "vhub_bgp_ip" {
  value = azurerm_virtual_hub.vhub.virtual_router_ips
}
