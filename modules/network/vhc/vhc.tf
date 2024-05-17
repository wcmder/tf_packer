terraform {
  required_version = ">=1.0.2"
}

resource "azurerm_virtual_hub_connection" "vhc" {
  for_each                  = var.vhc
  name                      = each.value.name
  remote_virtual_network_id = each.value.vnet_id
  virtual_hub_id            = var.vhub_id

  routing {
    associated_route_table_id = each.value.a_rtb_id
    
    propagated_route_table {
      route_table_ids = each.value.p_rtb_ids
      labels          = each.value.labels
    }

    dynamic "static_vnet_route" {
      for_each = each.value.static_vnet_route == null ? {} : each.value.static_vnet_route
      content {
        name                = "${static_vnet_route.key}"
        address_prefixes    = static_vnet_route.value.addr_prefixes
        next_hop_ip_address = static_vnet_route.value.next_hop_ip
      }

    }
  }
}

# this save VHC name and ID
output "vhc_name_id" {
  value = tomap(
    { for s in azurerm_virtual_hub_connection.vhc : s.name => s.id }
  )
}
