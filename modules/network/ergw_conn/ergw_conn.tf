# last udpate Oct2023

terraform {
  required_version = ">=1.6.2"
}


resource "azurerm_express_route_connection" "ergw_conn" {
  for_each                             = var.ergw_conn
  name                                 = join("-", [var.common["env"], each.value.ergw_conn_name])
  express_route_gateway_id             = each.value.ergw_id
  express_route_circuit_peering_id     = each.value.erpeering_id
  enable_internet_security             = each.value.inet_security
  express_route_gateway_bypass_enabled = each.value.bypass
  routing_weight                       = each.value.routing_weight

  dynamic "routing" {
    for_each = each.value.routing == null ? {} : each.value.routing
    content {
      associated_route_table_id = routing.value.assc_rt_id
      inbound_route_map_id      = routing.value.in_route_map_id
      outbound_route_map_id     = routing.value.out_route_map_id

      dynamic "propagated_route_table" {
        for_each = routing.value.propagated_route_table == null ? {} : routing.value.propagated_route_table
        content {
          labels          = propagated_route_table.value.label_name_list
          route_table_ids = propagated_route_table.value.rt_id_list
        }
      }
    }
  }

  timeouts {}
}


output "ergw_conn_name_id" {
  value = tomap(
    { for e in azurerm_express_route_connection.ergw_conn : replace(e.name, "/^${var.common["env"]}-/", "") => e.id }
  )
}
