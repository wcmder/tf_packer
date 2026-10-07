resource "azurerm_vpn_gateway" "vpngw" {
  name                = join("-", [var.common["env"], var.name])
  location            = var.common["reg"]
  resource_group_name = var.common["rsg_name"]
  virtual_hub_id      = var.vhub_id
  scale_unit          = var.scale_unit

  tags = merge(var.common["tags"], { "ResourceType" = "VPN Gateway" })

}


output "vpngw_id" {
  value = azurerm_vpn_gateway.vpngw.id
}


output "inst0_bgp_ip" {
  value = tolist(azurerm_vpn_gateway.vpngw.bgp_settings[0].instance_0_bgp_peering_address[0].default_ips)[0]
}

output "inst0_tun_private_ip" {
  value = tolist(azurerm_vpn_gateway.vpngw.bgp_settings[0].instance_0_bgp_peering_address[0].tunnel_ips)[0]
}

output "inst0_tun_public_ip" {
  value = tolist(azurerm_vpn_gateway.vpngw.bgp_settings[0].instance_0_bgp_peering_address[0].tunnel_ips)[1]
}

output "inst1_bgp_ip" {
  value = tolist(azurerm_vpn_gateway.vpngw.bgp_settings[0].instance_1_bgp_peering_address[0].default_ips)[0]
}

output "inst1_tun_private_ip" {
  value = tolist(azurerm_vpn_gateway.vpngw.bgp_settings[0].instance_1_bgp_peering_address[0].tunnel_ips)[0]
}

output "inst1_tun_public_ip" {
  value = tolist(azurerm_vpn_gateway.vpngw.bgp_settings[0].instance_1_bgp_peering_address[0].tunnel_ips)[1]
}
