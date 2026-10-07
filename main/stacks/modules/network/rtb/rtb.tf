locals {
  prepend = ""
}

resource "azurerm_route_table" "rtb" {
  for_each                      = var.rtb
  name                          = each.value.vnet_name == null ? join("-", [var.common["env"], each.key]) : join("-", [each.value.vnet_name, each.key])
  resource_group_name           = var.common["rsg_name"]
  location                      = var.common["reg"]
  bgp_route_propagation_enabled = each.value.bgp_route_propagation_enabled

  dynamic "route" {
    for_each = each.value.route == null ? {} : each.value.route
    content {
      name                   = route.key
      address_prefix         = route.value.prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_ip
    }
  }

  tags = merge(var.common["tags"], { "ResourceType" = "Route Table" })
}


output "rtb_name_name" {
  value = tomap(
    { for k, e in azurerm_route_table.rtb : k => e.name }
  )
}



output "rtb_name_id" {
  value = tomap(
    { for k, e in azurerm_route_table.rtb : k => e.id }
  )
}
