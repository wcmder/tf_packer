terraform {
  required_version = ">=1.0.2"
}

resource "azurerm_virtual_network_gateway" "vngw" {
  name                = join("_", [var.common["env"], var.name])
  location            = var.common["rsg_location"]
  resource_group_name = var.common["rsg_name"]

  type     = var.type
  vpn_type = var.vpn_type

  active_active = var.active_active
  enable_bgp    = var.enable_bgp
  sku           = var.sku
  generation    = var.generation

  dynamic "bgp_settings" {
    for_each = var.bgp_settings == null ? {} : var.bgp_settings
    content {
      asn = bgp_settings.value.bgp_asn
    }
  }


  dynamic "ip_configuration" {
    for_each = var.ip_configuration == null ? {} : var.ip_configuration
    content {
      name                          = ip_configuration.key
      public_ip_address_id          = ip_configuration.value.gw_pip_id
      private_ip_address_allocation = ip_configuration.value.method
      subnet_id                     = ip_configuration.value.subnet_id
    }
  }

  tags = merge(var.common["tags"], { "ResourceType" = "VPN ER Gateway" })

}

output "vngw_name" {
  value = azurerm_virtual_network_gateway.vngw.name

}

output "vngw_id" {
  value = azurerm_virtual_network_gateway.vngw.id

}
