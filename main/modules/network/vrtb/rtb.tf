terraform {
  required_version = ">=1.0.2"
  #experiments = [module_variable_optional_attrs]
}

resource "azurerm_virtual_hub_route_table" "rtb" {
  for_each       = var.rtb
  name           = each.value.name
  virtual_hub_id = var.vhub_id
  labels         = each.value.labels
  
  dynamic "route" {
    for_each = each.value.route == null ? {} : each.value.route
    content {
      name              = route.value.name
      destinations_type = "CIDR"
      destinations      = route.value.dest # this is a list []
      next_hop_type     = "ResourceId"
      next_hop          = route.value.nexthop # this is vnc or firewall ID if secure hub used
    }
  }

  #tags = merge(var.common["tags"], {"ResourceType" = "vHub Route Table"})

}

output "rtb_name_id" {
  value = tomap(
    { for s in azurerm_virtual_hub_route_table.rtb : s.name => s.id }
  )
}
