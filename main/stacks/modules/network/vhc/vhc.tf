resource "azurerm_virtual_hub_connection" "vhc" {
  for_each                  = var.vhc
  name                      = each.key
  remote_virtual_network_id = each.value.vnet_id
  virtual_hub_id            = var.vhub_id
  internet_security_enabled = each.value.internet_security_enabled
  dynamic "routing" {
    for_each = each.value.routing == null ? {} : each.value.routing
    content {
      associated_route_table_id = routing.value.a_rtb_id
      propagated_route_table {
        route_table_ids = routing.value.p_rtb_ids
        labels          = routing.value.labels
      }

      inbound_route_map_id  = routing.value.inbound_route_map_id
      outbound_route_map_id = routing.value.outbound_route_map_id

      dynamic "static_vnet_route" {
        for_each = routing.value.static_vnet_route == null ? {} : routing.value.static_vnet_route
        content {
          name                = static_vnet_route.key
          address_prefixes    = static_vnet_route.value.addr_prefixes
          next_hop_ip_address = static_vnet_route.value.next_hop_ip
        }
      }
      static_vnet_local_route_override_criteria = routing.value.static_vnet_local_route_override_criteria
      #static_vnet_propagate_static_routes_enabled = routing.value.static_vnet_propagate_static_routes_enabled
    }
  }
}

# this save VHC name and ID
output "vhc_name_id" {
  value = tomap(
    { for s in azurerm_virtual_hub_connection.vhc : s.name => s.id }
  )
}
