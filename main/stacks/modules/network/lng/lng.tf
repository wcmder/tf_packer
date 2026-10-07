resource "azurerm_local_network_gateway" "lng" {
  name                = join("-", [var.common["env"], var.name])
  location            = var.common["reg"]
  resource_group_name = var.common["rsg_name"]
  gateway_address     = var.gw_pip_addr

  dynamic "bgp_settings" {
    for_each = var.bgp_settings == null ? {} : var.bgp_settings
    content {
      asn                 = bgp_settings.value.bgp_asn
      bgp_peering_address = bgp_settings.value.peer_ip
    }

  }

  address_space = var.local_prefix_list

  tags = merge(var.common["tags"], { "ResourceType" = "Local Network Gateway" })

}

output "lng_name" {
  value = azurerm_local_network_gateway.lng.name

}

output "lng_id" {
  value = azurerm_local_network_gateway.lng.id
}