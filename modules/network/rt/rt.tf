
resource "azurerm_route" "rt" {
  for_each               = var.rtbs
  resource_group_name    = var.common["rsg_name"]
  name                   = var.route["name"]
  address_prefix         = var.route["prefix"]
  next_hop_type          = var.route["next_hop_type"]
  next_hop_in_ip_address = var.route["next_hop_ip"]
  route_table_name       = each.value

}