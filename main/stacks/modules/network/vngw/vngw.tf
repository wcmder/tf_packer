resource "azurerm_virtual_network_gateway" "vngw" {
  name                = join("_", [var.common["env"], var.name])
  location            = var.common["rsg_location"]
  resource_group_name = var.common["rsg_name"]

  type     = var.type
  vpn_type = var.vpn_type

  active_active = var.active_active
  bgp_enabled   = var.enable_bgp
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

  dynamic "custom_route" {
    for_each = var.custom_route == null ? [] : [var.custom_route]

    content {
      address_prefixes = custom_route.value.address_prefixes
    }
  }

  dynamic "vpn_client_configuration" {
    for_each = var.vpn_client_configuration == null ? [] : [var.vpn_client_configuration]

    content {
      address_space         = vpn_client_configuration.value.address_space
      aad_audience          = vpn_client_configuration.value.aad_audience
      aad_issuer            = vpn_client_configuration.value.aad_issuer
      aad_tenant            = vpn_client_configuration.value.aad_tenant
      radius_server_address = vpn_client_configuration.value.radius_server_address
      radius_server_secret  = vpn_client_configuration.value.radius_server_secret
      vpn_auth_types        = vpn_client_configuration.value.vpn_auth_types
      vpn_client_protocols  = vpn_client_configuration.value.vpn_client_protocols

      dynamic "ipsec_policy" {
        for_each = vpn_client_configuration.value.ipsec_policy == null ? [] : [vpn_client_configuration.value.ipsec_policy]

        content {
          dh_group                  = ipsec_policy.value.dh_group
          ike_encryption            = ipsec_policy.value.ike_encryption
          ike_integrity             = ipsec_policy.value.ike_integrity
          ipsec_encryption          = ipsec_policy.value.ipsec_encryption
          ipsec_integrity           = ipsec_policy.value.ipsec_integrity
          pfs_group                 = ipsec_policy.value.pfs_group
          sa_data_size_in_kilobytes = ipsec_policy.value.sa_data_size_in_kilobytes
          sa_lifetime_in_seconds    = ipsec_policy.value.sa_lifetime_in_seconds
        }
      }

      dynamic "radius_server" {
        for_each = vpn_client_configuration.value.radius_servers

        content {
          address = radius_server.value.address
          score   = radius_server.value.score
          secret  = radius_server.value.secret
        }
      }

      dynamic "revoked_certificate" {
        for_each = vpn_client_configuration.value.revoked_certificates

        content {
          name       = revoked_certificate.value.name
          thumbprint = revoked_certificate.value.thumbprint
        }
      }

      dynamic "root_certificate" {
        for_each = vpn_client_configuration.value.root_certificates

        content {
          name             = root_certificate.value.name
          public_cert_data = root_certificate.value.public_cert_data
        }
      }

      dynamic "virtual_network_gateway_client_connection" {
        for_each = vpn_client_configuration.value.client_connections

        content {
          address_prefixes   = virtual_network_gateway_client_connection.value.address_prefixes
          name               = virtual_network_gateway_client_connection.value.name
          policy_group_names = virtual_network_gateway_client_connection.value.policy_group_names
        }
      }
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
