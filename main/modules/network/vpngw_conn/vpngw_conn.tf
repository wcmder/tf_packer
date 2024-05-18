terraform {
  required_version = ">=1.0.2"
}


resource "azurerm_vpn_gateway_connection" "vpngw_conn" {
  name               = join("-", [var.common["env"], var.name])
  vpn_gateway_id     = var.vpngw_id
  remote_vpn_site_id = var.vpnsite_id

  dynamic "vpn_link" {
    for_each = var.vpn_link
    content {
      name                                  = vpn_link.value.link_name
      vpn_site_link_id                      = vpn_link.value.link_id
      shared_key                            = vpn_link.value.link_ipsec_key
      bgp_enabled                           = vpn_link.value.enable_bgp
      policy_based_traffic_selector_enabled = vpn_link.value.policy_based_enable
      dynamic "ipsec_policy" {
        for_each = vpn_link.value.ipsec_policy == null ? {} : vpn_link.value.ipsec_policy
        content {
          dh_group                 = ipsec_policy.value.dh_group
          ike_encryption_algorithm = ipsec_policy.value.ike_encryption
          ike_integrity_algorithm  = ipsec_policy.value.ike_integrity
          encryption_algorithm     = ipsec_policy.value.ipsec_encryption
          integrity_algorithm      = ipsec_policy.value.ipsec_integrity
          pfs_group                = ipsec_policy.value.pfs_group
          sa_data_size_kb          = ipsec_policy.value.sa_data_size_kb
          sa_lifetime_sec          = ipsec_policy.value.sa_lifetime_sec
        }
      }
    }
  }
  dynamic "routing" {
    for_each = var.routing == null ? {} : var.routing
    content {
      associated_route_table = routing.value.associated_route_table
      propagated_route_table {
        route_table_ids = routing.value.p_route_table_ids
        labels          = routing.value.p_labels
      }
    }
  }

  dynamic "traffic_selector_policy" {
    for_each = var.traffic_selector_policy == null ? {} : var.traffic_selector_policy
    content {
      local_address_ranges = traffic_selector_policy.value.local_addr_ranges
      remote_address_ranges = traffic_selector_policy.value.remote_addr_ranges
    }
  }
}
