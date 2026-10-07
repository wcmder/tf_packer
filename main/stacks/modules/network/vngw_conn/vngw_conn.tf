resource "azurerm_virtual_network_gateway_connection" "vpngw_conn" {
  name                = join("_", [var.common["env"], var.name])
  location            = var.common["rsg_location"]
  resource_group_name = var.common["rsg_name"]

  type                       = var.type
  express_route_circuit_id   = var.ercircuit_id
  virtual_network_gateway_id = var.vngw_id

  local_network_gateway_id       = var.lng_id
  connection_protocol            = var.ike
  shared_key                     = var.ipsec_key
  bgp_enabled                    = var.enable_bgp
  local_azure_ip_address_enabled = var.azure_ip


  dynamic "ipsec_policy" {
    for_each = var.ipsec_policy == null ? {} : var.ipsec_policy
    content {
      dh_group         = ipsec_policy.value.dh_group
      ike_encryption   = ipsec_policy.value.ike_encryption
      ike_integrity    = ipsec_policy.value.ike_integrity
      ipsec_encryption = ipsec_policy.value.ipsec_encryption
      ipsec_integrity  = ipsec_policy.value.ipsec_integrity
      pfs_group        = ipsec_policy.value.pfs_group
      sa_datasize      = ipsec_policy.value.sa_data_size_kb
      sa_lifetime      = ipsec_policy.value.sa_lifetime_sec
    }
  }


  tags = merge(var.common["tags"], { "ResourceType" = "ER Gateway Connection" })

}

