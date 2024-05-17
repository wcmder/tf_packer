terraform {
  required_version = ">=1.0.2"
}

resource "azurerm_network_security_group" "nsg" {

  for_each            = var.nsg
  name                = var.common["env"] == null ? each.value.nsg_name : join("-", [var.common["env"], each.value.nsg_name])
  resource_group_name = var.common["rsg_name"]
  location            = var.common["reg"]

  dynamic "security_rule" {
    for_each = each.value.security_rule == null ? {} : each.value.security_rule
    content {
      name                         = security_rule.value.name
      priority                     = security_rule.value.priority
      direction                    = security_rule.value.direction
      access                       = security_rule.value.access
      protocol                     = security_rule.value.protocol
      source_port_range            = security_rule.value.src_port_range
      destination_port_range       = security_rule.value.dst_port_range
      source_port_ranges           = security_rule.value.src_port_ranges
      destination_port_ranges      = security_rule.value.dst_port_ranges
      source_address_prefix        = security_rule.value.src_addr_prefix
      destination_address_prefix   = security_rule.value.dst_addr_prefix
      source_address_prefixes      = security_rule.value.src_addr_prefixes
      destination_address_prefixes = security_rule.value.dst_addr_prefixes
    }
  }

  tags = merge(var.common["tags"], { "ResourceType" = "NSG" })

}

output "nsg_name_id" {
  value = tomap(
    { for e in azurerm_network_security_group.nsg : "${var.common["env"]}" == null ? e.name : replace(e.name, "/^${var.common["env"]}-/", "") => e.id }
  )
}

output "nsg_name_name" {
  value = tomap(
    { for e in azurerm_network_security_group.nsg : "${var.common["env"]}" == null ? e.name : replace(e.name, "/^${var.common["env"]}-/", "") => e.name }
  )
}
