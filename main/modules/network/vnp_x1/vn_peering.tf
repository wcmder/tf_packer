terraform {
  required_version = ">=1.0.2"
}


resource "azurerm_virtual_network_peering" "x_to_one" {
  for_each                     = var.vnpeer_do ? var.vnet_local : {}
  resource_group_name          = var.common["rsg_name"]
  virtual_network_name         = each.value.vnet_local_name
  name                         = each.value.peering_name
  remote_virtual_network_id    = var.vnet_remote_id
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  allow_gateway_transit        = var.allow_gateway_transit
  use_remote_gateways          = var.use_remote_gateways

}


