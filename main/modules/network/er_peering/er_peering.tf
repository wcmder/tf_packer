# last udpate Oct2023

resource "azurerm_express_route_circuit_peering" "er_peering" {

  for_each                      = var.peering
  peering_type                  = each.value.type
  express_route_circuit_name    = each.value.ercc_name
  resource_group_name           = var.common["rsg_name"]
  shared_key                    = each.value.bgp_key
  peer_asn                      = each.value.peer_bgp_asn
  primary_peer_address_prefix   = each.value.prim_prefix
  secondary_peer_address_prefix = each.value.secd_prefix
  vlan_id                       = each.value.vlan
  ipv4_enabled                  = each.value.ipv4_enabled
  route_filter_id               = each.value.route_filter_id

  dynamic "microsoft_peering_config" {
    for_each = each.value.microsoft_peering_config == null ? {} : each.value.microsoft_peering_config
    content {
      advertised_public_prefixes = microsoft_peering_config.value.adv_prefix_list
      customer_asn               = microsoft_peering_config.value.customer_asn
      routing_registry_name      = microsoft_peering_config.value.registry_name
      advertised_communities     = microsoft_peering_config.value.adv_comm_list
    }
  }

  timeouts { }
}


output "peering_id_list" {
  value = tolist(
    [for e in azurerm_express_route_circuit_peering.er_peering : e.id]
  )
}

output "peering_ms_asn" {
  value = tolist(
    [for e in azurerm_express_route_circuit_peering.er_peering : e.azure_asn]
  )[0]
}