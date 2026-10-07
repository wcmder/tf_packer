# last udpate Oct2023

resource "azurerm_firewall_policy_rule_collection_group" "fw_rcg" {
  name               = join("-", [var.common["env"], var.fw_rcg_name])
  firewall_policy_id = var.fw_policy_id
  priority           = var.priority

  dynamic "network_rule_collection" {
    for_each = var.network_rule_collection == null ? {} : var.network_rule_collection
    content {
      name     = network_rule_collection.key
      priority = network_rule_collection.value.priority
      action   = network_rule_collection.value.action

      dynamic "rule" {
        for_each = network_rule_collection.value.rule
        content {
          name                  = rule.key
          source_addresses      = rule.value.src_addr_list
          source_ip_groups      = rule.value.src_ipgrp_list
          destination_addresses = rule.value.dst_addr_list
          destination_ip_groups = rule.value.dst_ipgrp_list
          destination_ports     = rule.value.dst_port_list
          protocols             = rule.value.protocol_list
          destination_fqdns     = rule.value.dst_fqdn_list
        }
      }
    }
  }

  dynamic "application_rule_collection" {
    for_each = var.application_rule_collection == null ? {} : var.application_rule_collection
    content {
      name     = application_rule_collection.key
      priority = application_rule_collection.value.priority
      action   = application_rule_collection.value.action

      dynamic "rule" {
        for_each = application_rule_collection.value.rule
        content {
          name                  = rule.key
          source_addresses      = rule.value.src_addr_list
          source_ip_groups      = rule.value.src_ipgrp_list
          destination_addresses = rule.value.dst_addr_list
          destination_urls      = rule.value.dst_url_list
          destination_fqdns     = rule.value.dst_fqdn_list
          destination_fqdn_tags = rule.value.dst_fqdn_tag_list
          terminate_tls         = rule.value.terminate_tls
          web_categories        = rule.value.web_category_list

          dynamic "protocols" {
            for_each = rule.value.protocols
            content {
              type = protocols.value.type
              port = protocols.value.port
            }
          }
        }
      }
    }
  }

}
