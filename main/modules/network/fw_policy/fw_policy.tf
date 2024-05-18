# last udpate Oct2023

terraform {
  required_version = ">=1.6.2"
}

resource "azurerm_firewall_policy" "fw_policy" {
  name                              = join("-", [var.common["env"], var.fw_policy_name])
  resource_group_name               = var.common["rsg_name"]
  location                          = var.common["reg"]
  base_policy_id                    = var.parent_policy_id
  sku                               = var.sku
  auto_learn_private_ranges_enabled = var.auto_learn_private_ips
  threat_intelligence_mode          = var.threat_intel_mode
  sql_redirect_allowed              = var.sql_redirect

  dynamic "dns" {
    for_each = var.dns == null ? {} : var.dns
    content {
      proxy_enabled = dns.value.enabled
      servers       = dns.value.servers
    }
  }

  dynamic "insights" {
    for_each = var.insights == null ? {} : var.insights
    content {
      enabled                            = insights.value.enabled
      default_log_analytics_workspace_id = insights.value.default_la_wks_id
      retention_in_days                  = insights.value.retention_days

      dynamic "log_analytics_workspace" {
        for_each = insights.value.log_analytics_workspace == null ? {} : insights.value.log_analytics_workspace
        content {
          id                = log_analytics_workspace.value.la_wks_id
          firewall_location = log_analytics_workspace.value.fw_location
        }
      }
    }
  }

  dynamic "intrusion_detection" {
    for_each = var.intrusion_detection == null ? {} : var.intrusion_detection
    content {
      mode           = intrusion_detection.value.mode
      private_ranges = intrusion_detection.value.private_ranges_list

      dynamic "signature_overrides" {
        for_each = intrusion_detection.value.signature_overrides == null ? {} : intrusion_detection.value.signature_overrides
        content {
          id    = signature_overrides.value.signature_id
          state = signature_overrides.value.state
        }
      }

      dynamic "traffic_bypass" {
        for_each = intrusion_detection.value.traffic_bypass == null ? {} : intrusion_detection.value.traffic_bypass
        content {
          name                  = traffic_bypass.value.name
          protocol              = traffic_bypass.value.protocol
          description           = traffic_bypass.value.description
          destination_addresses = traffic_bypass.value.dst_addr_list
          destination_ip_groups = traffic_bypass.value.dst_ip_grp_list
          destination_ports     = traffic_bypass.value.dst_port_list
          source_addresses      = traffic_bypass.value.src_addr_list
          source_ip_groups      = traffic_bypass.value.src_ip_grp_list
        }
      }
    }
  }

  dynamic "threat_intelligence_allowlist" {
    for_each = var.threat_intelligence_allowlist == null ? {} : var.threat_intelligence_allowlist
    content {
      fqdns        = threat_intelligence_allowlist.value.fqdn_list
      ip_addresses = threat_intelligence_allowlist.value.ip_addr_list
    }
  }

  dynamic "tls_certificate" {
    for_each = var.tls_certificate == null ? {} : var.tls_certificate
    content {
      name                = tls_certificate.value.name
      key_vault_secret_id = tls_certificate.value.kv_secret_id
    }
  }

  dynamic "explicit_proxy" {
    for_each = var.explicit_proxy == null ? {} : var.explicit_proxy
    content {
      enabled         = explicit_proxy.value.enabled
      http_port       = explicit_proxy.value.http_port
      https_port      = explicit_proxy.value.https_port
      enable_pac_file = explicit_proxy.value.enable_pac_file
      pac_file_port   = explicit_proxy.value.pac_file_port
      pac_file        = explicit_proxy.value.pac_file
    }
  }

  tags = merge({ for k, v in var.common["tags"] : lower(k) => v }, { "resourcetype" = "Firewall Policy" })

}




output "fw_policy_id" {
  value = azurerm_firewall_policy.fw_policy.id

}
