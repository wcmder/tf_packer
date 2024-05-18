locals {
  prepend = ""
}

resource "azurerm_route_table" "rtb" {
  for_each       = var.rtb
  name           = each.value.vnet_name == null ? join("-", [var.common["env"], each.value.name]) : join("-", [each.value.vnet_name, each.value.name])
  resource_group_name = var.common["rsg_name"]
  location            = var.common["reg"]
  disable_bgp_route_propagation = each.value.disable_bgp_propagation

  dynamic "route" {
    for_each = each.value.route == null ? {} : each.value.route
    content {
      name                   = route.value.name
      address_prefix         = route.value.prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_ip
    }
  }

  tags = merge(var.common["tags"], {"ResourceType" = "Route Table"})
}


output "rtb_name_name" {
  value = tomap(
    #{ for e in azurerm_route_table.rtb : replace(e.name, "/^.*[vV][nN][0-9][0-9]+_/", "") => e.name }
    { for e in azurerm_route_table.rtb : replace(e.name, "/^${var.common["env"]}-/", "") => e.name }
  )
}



output "rtb_name_id" {
  value = tomap(
    #{ for e in azurerm_route_table.rtb : replace(e.name, "/^.*[vV][nN][0-9][0-9]+_/", "") => e.id }
    { for e in azurerm_route_table.rtb : replace(e.name, "/^${var.common["env"]}-/", "") => e.id }
  )
}