terraform {
  required_version = ">=1.0.2"
}


resource "azurerm_network_security_rule" "nsr_xg" {
  name                         = var.name
  priority                     = var.priority
  direction                    = var.direction
  access                       = var.access
  protocol                     = var.protocol
  source_port_range            = var.src_port_range
  destination_port_range       = var.dst_port_range
  source_port_ranges           = var.src_port_ranges
  destination_port_ranges      = var.dst_port_ranges
  source_address_prefix        = var.src_addr_prefix
  destination_address_prefix   = var.dst_addr_prefix
  source_address_prefixes       = var.src_addr_prefixes
  destination_address_prefixes  = var.dst_addr_prefixes
  resource_group_name         = var.common["rsg_name"]
  for_each                    = toset(var.nsg)
  network_security_group_name = each.value
}
