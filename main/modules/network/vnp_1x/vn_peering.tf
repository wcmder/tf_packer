terraform {
  required_version = ">=1.0.2"
}


resource "azurerm_virtual_network_peering" "one_to_x" {
  for_each                     = var.vnpeer_do ? var.vnet_remote : {}
  resource_group_name          = var.common["rsg_name"]
  remote_virtual_network_id    = each.value.vnet_remote_id
  name                         = each.value.peering_name
  virtual_network_name         = var.vnet_local_name
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  allow_gateway_transit        = var.allow_gateway_transit
  use_remote_gateways          = var.use_remote_gateways

}


