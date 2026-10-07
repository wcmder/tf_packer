# bastion nsg
module "bastion_nsg" {
  source = "../nsg"
  common = var.common
  nsg = {

    (var.nsg_name) : {
      security_rule = {
        allow_https_from_internet : {
          priority        = 100
          direction       = "Inbound"
          access          = "Allow"
          protocol        = "*"
          src_port_range  = "*"
          dst_port_range  = "443"
          src_addr_prefix = "Internet"
          dst_addr_prefix = "*"
        }
        allow_https_from_gatewaymanager : {
          priority        = 110
          direction       = "Inbound"
          access          = "Allow"
          protocol        = "*"
          src_port_range  = "*"
          dst_port_range  = "443"
          src_addr_prefix = "GatewayManager"
          dst_addr_prefix = "*"
        }
        allow_ssh_rdp_out : {
          priority        = 100
          direction       = "Outbound"
          access          = "Allow"
          protocol        = "*"
          src_port_range  = "*"
          dst_port_ranges = ["22", "3389"]
          src_addr_prefix = "*"
          dst_addr_prefix = "VirtualNetwork"
        }
        allow_azurecloud_out : {
          priority        = 110
          direction       = "Outbound"
          access          = "Allow"
          protocol        = "*"
          src_port_range  = "*"
          dst_port_range  = "443"
          src_addr_prefix = "*"
          dst_addr_prefix = "AzureCloud"
        }
        allow_bast_comm_out : {
          priority        = 120
          direction       = "Outbound"
          access          = "Allow"
          protocol        = "*"
          src_port_range  = "*"
          dst_port_range  = "*"
          src_addr_prefix = "VirtualNetwork"
          dst_addr_prefix = "VirtualNetwork"
        }
        allow_get_session_out : {
          priority        = 130
          direction       = "Outbound"
          access          = "Allow"
          protocol        = "*"
          src_port_range  = "*"
          dst_port_range  = "80"
          src_addr_prefix = "*"
          dst_addr_prefix = "Internet"
        }
      }
    }
  }
}


output "nsg_name_id" {
  value = module.bastion_nsg.nsg_name_id
}

output "nsg_name_name" {
  value = module.bastion_nsg.nsg_name_name
}
