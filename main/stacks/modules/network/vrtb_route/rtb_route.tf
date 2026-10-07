

resource "azurerm_virtual_hub_route_table_route" "rt" {
  route_table_id = var.route_table_id

  for_each          = var.route
  name              = each.key
  destinations_type = each.value.dest_type
  destinations      = each.value.dst_list
  next_hop_type     = each.value.hop_type
  next_hop          = each.value.next_hop

}