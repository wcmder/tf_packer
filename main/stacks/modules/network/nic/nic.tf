# last udpate Oct2023

resource "azurerm_network_interface" "nic" {
  for_each            = var.nic
  name                = join("-", [var.common["env"], each.value.nic_name])
  location            = var.common["reg"]
  resource_group_name = var.common["rsg_name"]

  auxiliary_mode                 = each.value.auxiliary_mode
  auxiliary_sku                  = each.value.auxiliary_sku
  dns_servers                    = each.value.dns_server_list
  edge_zone                      = each.value.edge_zone
  ip_forwarding_enabled          = each.value.ip_forwarding
  accelerated_networking_enabled = each.value.accelerated_networking
  internal_dns_name_label        = each.value.internal_dns_name_label

  dynamic "ip_configuration" {
    for_each = each.value.ip_configuration
    content {
      name                                               = ip_configuration.key
      subnet_id                                          = ip_configuration.value.subnet_id
      private_ip_address_allocation                      = ip_configuration.value.mode # "Dynamic"
      gateway_load_balancer_frontend_ip_configuration_id = ip_configuration.value.gwlb_frontend_ip_configu_id
      private_ip_address_version                         = ip_configuration.value.version
      public_ip_address_id                               = ip_configuration.value.public_ip_addr_id
      primary                                            = ip_configuration.value.primary

    }
  }
}




# This save subnet name and ID
output "nic_name_id" {
  value = tomap(
    { for k, e in azurerm_network_interface.nic : k => e.id }
  )
}

# This save subnet name and name
output "nic_name_name" {
  value = tomap(
    { for k, e in azurerm_network_interface.nic : k => e.name }
  )
}

output "nic_name_private_ip" {
  value = tomap(
    { for k, e in azurerm_network_interface.nic : k => e.private_ip_address }
  )
}

output "nic_name_internal_dns_suffix" {
  value = tomap(
    { for k, e in azurerm_network_interface.nic : k => e.internal_domain_name_suffix }
  )
}
