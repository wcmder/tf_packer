# bastion nsg
module "bastion_nsg" {
  source = "../nsg"
  common = var.common
  nsg = {

    nsg : {
      nsg_name = var.nsg_name
      security_rule = {
        int : {
          name            = "allow_https_from_internet"
          priority        = 100
          direction       = "Inbound"
          access          = "Allow"
          protocol        = "*"
          src_port_range  = "*"
          dst_port_range  = "443"
          src_addr_prefix = "Internet"
          dst_addr_prefix = "*"
        }
        gwmgr : {
          name            = "allow_https_from_gatewaymanager"
          priority        = 110
          direction       = "Inbound"
          access          = "Allow"
          protocol        = "*"
          src_port_range  = "*"
          dst_port_range  = "443"
          src_addr_prefix = "GatewayManager"
          dst_addr_prefix = "*"
        }
        ssh-rdp : {
          name            = "allow_ssh_rdp_out"
          priority        = 100
          direction       = "Outbound"
          access          = "Allow"
          protocol        = "*"
          src_port_range  = "*"
          dst_port_ranges = ["22", "3389"]
          src_addr_prefix = "*"
          dst_addr_prefix = "VirtualNetwork"
        }
        azurecloud : {
          name            = "allow_azurecloud_out"
          priority        = 110
          direction       = "Outbound"
          access          = "Allow"
          protocol        = "*"
          src_port_range  = "*"
          dst_port_range  = "443"
          src_addr_prefix = "*"
          dst_addr_prefix = "AzureCloud"
        }
        bsa-comm : {
          name            = "allow_bast_comm_out"
          priority        = 120
          direction       = "Outbound"
          access          = "Allow"
          protocol        = "*"
          src_port_range  = "*"
          dst_port_range  = "*"
          src_addr_prefix = "VirtualNetwork"
          dst_addr_prefix = "VirtualNetwork"
        }
        get-ses : {
          name            = "allow_get_session_out"
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