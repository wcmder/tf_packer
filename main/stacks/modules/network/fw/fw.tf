# last udpate Oct2023

resource "azurerm_firewall" "fw" {
  name                = join("-", [var.common["env"], var.fw_name])
  resource_group_name = var.common["rsg_name"]
  location            = var.common["reg"]
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier
  threat_intel_mode   = var.threat_intel_mode
  zones               = var.zone_list
  private_ip_ranges   = var.ip_range_list
  dns_servers         = var.dns_server_list
  firewall_policy_id  = var.fw_policy_id

  dynamic "virtual_hub" {
    for_each = var.virtual_hub == null ? {} : var.virtual_hub
    content {
      virtual_hub_id  = virtual_hub.value.vhub_id
      public_ip_count = virtual_hub.value.pip_count
    }
  }

  dynamic "ip_configuration" {
    for_each = var.ip_configuration == null ? {} : var.ip_configuration
    content {
      name                 = "${var.fw_name}-${ip_configuration.key}"
      subnet_id            = ip_configuration.value.subnet_id
      public_ip_address_id = ip_configuration.value.public_ip_address_id
    }
  }

  dynamic "management_ip_configuration" {
    for_each = var.management_ip_configuration == null ? {} : var.management_ip_configuration
    content {
      name                 = "${var.fw_name}-${management_ip_configuration.key}"
      subnet_id            = management_ip_configuration.value.subnet_id
      public_ip_address_id = management_ip_configuration.value.public_ip_address_id
    }
  }

  tags = merge(var.common["tags"], { "ResourceType" = "Azure Firewall" })
}



output "fw_name" {
  value = azurerm_firewall.fw.name

}

output "fw_id" {
  value = azurerm_firewall.fw.id

}


output "fw_private_ip" {
  value = var.ip_configuration == null ? azurerm_firewall.fw.virtual_hub[0].private_ip_address : azurerm_firewall.fw.ip_configuration[0].private_ip_address

}

output "fw_public_ip_list" {
  value = var.ip_configuration == null ? azurerm_firewall.fw.virtual_hub[0].public_ip_addresses : null

}