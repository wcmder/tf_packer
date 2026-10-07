# last udpate Nov2023

resource "azurerm_public_ip" "pip" {
  for_each                = var.pip
  name                    = join("-", [var.common["env"], each.key])
  resource_group_name     = var.common["rsg_name"]
  location                = var.common["reg"]
  allocation_method       = each.value.method
  sku                     = each.value.sku
  zones                   = each.value.zones
  public_ip_prefix_id     = each.value.ipprefix_id
  ddos_protection_mode    = each.value.ddos_protection_mode
  ddos_protection_plan_id = each.value.ddos_protection_plan_id
  idle_timeout_in_minutes = each.value.idle_timeout_in_minutes
  sku_tier                = each.value.sku_tier

  tags = merge(var.common["tags"], { "ResourceType" = "Public IP" })

}

output "pip_ip" {
  value = try(one(values(azurerm_public_ip.pip)).ip_address, null)
}


output "pip_id" {
  value = try(one(values(azurerm_public_ip.pip)).id, null)
}

output "pip_name_ip" {
  value = tomap(
    { for k, e in azurerm_public_ip.pip : k => e.ip_address }
  )
}

output "pip_name_id" {
  value = tomap(
    { for k, e in azurerm_public_ip.pip : k => e.id }
  )
}

output "pip_name_name" {
  value = tomap(
    { for k, e in azurerm_public_ip.pip : k => e.name }
  )
}
