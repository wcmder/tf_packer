terraform {
  required_version = ">=1.0.2"
}

resource "azurerm_subnet" "subnet" {
  for_each             = var.subnet
  name                 = contains(["GatewaySubnet", "AzureBastionSubnet", "AzureFirewallSubnet", "AzureFirewallManagementSubnet"], each.key) ? each.key : "${var.vnet_name}-${each.key}"
  address_prefixes     = each.value.cidr
  resource_group_name  = var.common["rsg_name"]
  virtual_network_name = var.vnet_name

  dynamic "delegation" {
    for_each = each.value.delegation == null ? {} : each.value.delegation
    content {
      name = delegation.value.name

      dynamic "service_delegation" {
        for_each = delegation.value.service_delegation
        content {
          name    = service_delegation.value.name
          actions = service_delegation.value.actions
        }
      }
    }

  }

  private_endpoint_network_policies             = each.value.private_endpoint_policy
  private_link_service_network_policies_enabled = each.value.private_link_policy
  service_endpoints                             = each.value.service_endpoints
  service_endpoint_policy_ids                   = each.value.service_endpoint_policy_ids

}


# This save subnet name and ID
output "subnet_name_id" {
  value = tomap(
    { for e in azurerm_subnet.subnet : replace(e.name, "/^${var.vnet_name}-/", "") => e.id }
  )
}

# This save subnet name and name
output "subnet_name_name" {
  value = tomap(
    { for e in azurerm_subnet.subnet : replace(e.name, "/^${var.vnet_name}-/", "") => e.name }
  )
}
