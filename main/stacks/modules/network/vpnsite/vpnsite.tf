resource "azurerm_vpn_site" "vpnsite" {
  name                = join("-", [var.common["env"], var.name])
  location            = var.common["reg"]
  resource_group_name = var.common["rsg_name"]
  virtual_wan_id      = var.vwan_id
  address_cidrs       = var.onprem_prefix_list

  dynamic "link" {
    for_each = var.link
    content {
      name          = link.key
      ip_address    = link.value.remote_ip
      speed_in_mbps = link.value.speed_in_mbps
      dynamic "bgp" {
        for_each = link.value.bgp == null ? {} : link.value.bgp
        content {
          asn             = bgp.value.bgp_asn
          peering_address = bgp.value.peer_ip
        }
      }
    }
  }

  tags = merge(var.common["tags"], { "ResourceType" = "VPN Site" })

}

output "vpnsite_id" {
  value = azurerm_vpn_site.vpnsite.id
}

output "vpnsite_link1_id" {
  value = azurerm_vpn_site.vpnsite.link[0].id
}

output "vpnsite_link2_id" {
  value = length(azurerm_vpn_site.vpnsite.link) == 2 ? azurerm_vpn_site.vpnsite.link[1].id : null
}
