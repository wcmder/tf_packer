# last udpate Oct2023

resource "azurerm_virtual_hub_routing_intent" "routing_intent" {
  name           = join("-", [var.common["env"], var.name])
  virtual_hub_id = var.vhub_id

  dynamic "routing_policy" {
    for_each = var.routing_policy == null ? {} : var.routing_policy
    content {
      name         = routing_policy.key
      destinations = routing_policy.value.destinations
      next_hop     = routing_policy.value.next_hop
    }
  }
}



output "id" {
  value = azurerm_virtual_hub_routing_intent.routing_intent.id
}
