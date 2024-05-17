# create or get resource group and subscription information
# main = true creates the resouce group and info
# main = false gets the info only
/*

module "main" {
  source       = "../../modules/main_demo"
  main         = true
  rsg_name     = "rg01"
  rsg_location = "East US"
  reg          = replace(lower("East US"), " ", "")
  svc_name     = "vhub1"
}


# pass into module call
locals {
  common = module.main.common
}



# creat vwan, resource name got prepended with env name
module "vwan" {
  source    = "../../modules/vwan"
  common    = local.common
  vwan_name = "vwan"
}


# create a hub, resource name got prepended with vWan name
module "vhub" {
  source     = "../../modules/vhub"
  common     = local.common
  hub_name   = "hub"
  vwan_id    = module.vwan.vwan_id
  hub_ipaddr = local.common.cidr.subnet.use.subnet_vhub[0]
}

# create a global firewall policy
module "fw_policy_global" {
  source         = "../../modules/fw_policy"
  common         = local.common
  fw_policy_name = "global-afwp"
  sku            = "Standard"
  dns = {
    global : {
      enabled = true
      servers = local.common.cidr.dns
    }
  }
}


# create a use firewall policy
module "fw_policy_use" {
  source           = "../../modules/fw_policy"
  common           = local.common
  fw_policy_name   = "use-afwp"
  parent_policy_id = module.fw_policy_global.fw_policy_id
  dns = {
    use : {
      enabled = true
      servers = local.common.cidr.dns
    }
  }
}


# create a use firewall policy
module "fw_policy_use2" {
  source           = "../../modules/fw_policy"
  common           = local.common
  fw_policy_name   = "use2-afwp"
  parent_policy_id = module.fw_policy_global.fw_policy_id
  dns = {
    use2 : {
      enabled = true
      servers = local.common.cidr.dns
    }
  }
}


# create a use firewall policy
module "fw_policy_aen" {
  source           = "../../modules/fw_policy"
  common           = local.common
  fw_policy_name   = "aen-afwp"
  parent_policy_id = module.fw_policy_global.fw_policy_id
  dns = {
    aen : {
      enabled = true
      servers = local.common.cidr.dns
    }
  }
}


# create a use firewall policy
module "fw_policy_ase" {
  source           = "../../modules/fw_policy"
  common           = local.common
  fw_policy_name   = "ase-afwp"
  parent_policy_id = module.fw_policy_global.fw_policy_id
  dns = {
    ase : {
      enabled = true
      servers = local.common.cidr.dns
    }
  }
}


# create a use firewall policy
module "fw_policy_asse" {
  source           = "../../modules/fw_policy"
  common           = local.common
  fw_policy_name   = "asse-afwp"
  parent_policy_id = module.fw_policy_global.fw_policy_id
  dns = {
    asse : {
      enabled = true
      servers = local.common.cidr.dns
    }
  }
}


# create a use firewall policy
module "fw_policy_aue" {
  source           = "../../modules/fw_policy"
  common           = local.common
  fw_policy_name   = "aue-afwp"
  parent_policy_id = module.fw_policy_global.fw_policy_id
  dns = {
    aue : {
      enabled = true
      servers = local.common.cidr.dns
    }
  }
}


# create a use firewall policy
module "fw_policy_brs" {
  source           = "../../modules/fw_policy"
  common           = local.common
  fw_policy_name   = "brs-afwp"
  parent_policy_id = module.fw_policy_global.fw_policy_id
  dns = {
    brs : {
      enabled = true
      servers = local.common.cidr.dns
    }
  }
}


# create a use firewall policy
module "fw_policy_cac" {
  source           = "../../modules/fw_policy"
  common           = local.common
  fw_policy_name   = "cac-afwp"
  parent_policy_id = module.fw_policy_global.fw_policy_id
  dns = {
    cac : {
      enabled = true
      servers = local.common.cidr.dns
    }
  }
}


# create a use firewall policy
module "fw_policy_dec" {
  source           = "../../modules/fw_policy"
  common           = local.common
  fw_policy_name   = "dec-afwp"
  parent_policy_id = module.fw_policy_global.fw_policy_id
  dns = {
    dec : {
      enabled = true
      servers = local.common.cidr.dns
    }
  }
}


# create a use firewall policy
module "fw_policy_jpe" {
  source           = "../../modules/fw_policy"
  common           = local.common
  fw_policy_name   = "jpe-afwp"
  parent_policy_id = module.fw_policy_global.fw_policy_id
  dns = {
    jpe : {
      enabled = true
      servers = local.common.cidr.dns
    }
  }
}


# create a use firewall policy
module "fw_policy_uks" {
  source           = "../../modules/fw_policy"
  common           = local.common
  fw_policy_name   = "uks-afwp"
  parent_policy_id = module.fw_policy_global.fw_policy_id
  dns = {
    uks : {
      enabled = true
      servers = local.common.cidr.dns
    }
  }
}


# for fw rcg definition config
locals {
  global_fw_policy_id = module.fw_policy_global.fw_policy_id
  use_fw_policy_id    = module.fw_policy_use.fw_policy_id
  use2_fw_policy_id   = module.fw_policy_use2.fw_policy_id
  aen_fw_policy_id    = module.fw_policy_aen.fw_policy_id
  ase_fw_policy_id    = module.fw_policy_ase.fw_policy_id
  asse_fw_policy_id   = module.fw_policy_asse.fw_policy_id
  aue_fw_policy_id    = module.fw_policy_aue.fw_policy_id
  brs_fw_policy_id    = module.fw_policy_brs.fw_policy_id
  cac_fw_policy_id    = module.fw_policy_cac.fw_policy_id
  dec_fw_policy_id    = module.fw_policy_dec.fw_policy_id
  jpe_fw_policy_id    = module.fw_policy_jpe.fw_policy_id
  uks_fw_policy_id    = module.fw_policy_uks.fw_policy_id
}
*/
/*
# create fw vnets
module "vnet" {
  source = "../../modules/vnet"
  common = local.common
  vnet = {
    "afw-vnet" : [local.common.cidr.vnet.use.vnet_fw, []]
  }
}


# create all subnets for the fw vnet, fw /26 , mgmt /26, bastion /26
module "fw_subnet" {
  source    = "../../modules/subnet"
  common    = local.common
  vnet_name = module.vnet.vnet_name_name["afw-vnet"]

  subnet = {
    AzureFirewallSubnet : {
      cidr = [local.common.cidr.subnet.use.subnet_fw[0]]
    }
    AzureFirewallManagementSubnet : {
      cidr = [local.common.cidr.subnet.use.subnet_fw[1]]
    }
    AzureBastionSubnet : {
      cidr = [local.common.cidr.subnet.use.subnet_fw[2]]
    }
  }
}

/*
# create /29 public IP range
module "ip_prefix" {
  source        = "../../modules/ipprefix"
  common        = local.common
  name          = "ippre"
  prefix_length = 29
}


# first fw public IP
module "fw_pip_1" {
  source      = "../../modules/pip"
  common      = local.common
  ipprefix_id = module.ip_prefix.ipprefix_id
  pip_name    = "${module.vnet.vnet_name_name["afw-vnet"]}-pip1"
}

# second fw public IP
module "fw_pip_2" {
  source      = "../../modules/pip"
  common      = local.common
  ipprefix_id = module.ip_prefix.ipprefix_id
  pip_name    = "${module.vnet.vnet_name_name["afw-vnet"]}-pip2"
}

# third fw public IP
module "fw_pip_3" {
  source      = "../../modules/pip"
  common      = local.common
  ipprefix_id = module.ip_prefix.ipprefix_id
  pip_name    = "${module.vnet.vnet_name_name["afw-vnet"]}-pip3"
}


# create a firewall
module "fw" {
  source       = "../../modules/fw"
  common       = local.common
  fw_name      = "use-afw"
  fw_policy_id = local.use_fw_policy_id
  #fw_policy_id = module.fw_policy_test.fw_policy_id
  zone_list = [1, 2]

  ip_configuration = {
    pip1 : {
      subnet_id            = module.fw_subnet.subnet_name_id["AzureFirewallSubnet"]
      public_ip_address_id = module.fw_pip_1.pip_id
    }
    pip2 : {
      subnet_id            = null
      public_ip_address_id = module.fw_pip_2.pip_id
    }

  }

  management_ip_configuration = {
    pip3-mgmt : {
      subnet_id            = module.fw_subnet.subnet_name_id["AzureFirewallManagementSubnet"]
      public_ip_address_id = module.fw_pip_3.pip_id
    }
  }
}


# local variables for fw connection and routing
locals {
  fw_vnc_name     = "${module.vnet.vnet_name_name["afw-vnet"]}-vnc"
  fw_ip           = module.fw.fw_private_ip
  fw_vnc_id       = module.vnc.vnc_name_id[local.fw_vnc_name]
  default_vrtb_id = "${module.vhub.vhub_id}/hubRouteTables/defaultRouteTable"
}


# Associate route table to virutal network connection
# a static default route pointing to internal FW ip, this route is inside VNC
module "vnc" {
  source  = "../../modules/vhc"
  vhub_id = module.vhub.vhub_id
  vnc = {

    fw : {
      name      = local.fw_vnc_name
      vnet_id   = module.vnet.vnet_name_id["afw-vnet"]
      a_rtb_id  = local.default_vrtb_id
      p_rtb_ids = [local.default_vrtb_id]
      labels    = ["default"]
      static_vnet_route = {
        afw-route : {
          addr_prefixes = ["0.0.0.0/0"]
          next_hop_ip   = local.fw_ip
        }
      }
    }
  }
}


# bastion public IP
module "bastin_pip" {
  source      = "../../modules/pip"
  common      = local.common
  ipprefix_id = module.ip_prefix.ipprefix_id
  pip_name    = "${module.vnet.vnet_name_name["afw-vnet"]}-bas-pip"
}


# bastion host
module "bastion" {
  source       = "../../modules/bastion"
  common       = local.common
  bastion_name = "bas"
  ip_name      = "ip"
  subnet_id    = module.fw_subnet.subnet_name_id["AzureBastionSubnet"]
  pip_id       = module.bastin_pip.pip_id
}



# create all vnets
module "vnets" {
  source = "../../modules/vnet"
  common = local.common
  vnet = {
    "infra-vnet" : [local.common.cidr.vnet.use.vnet_infra, [local.fw_ip]]
    "pe-vnet" : [local.common.cidr.vnet.use.vnet_pe, [local.fw_ip]]
    "avd-vnet" : [local.common.cidr.vnet.use.vnet_avd, [local.fw_ip]]
  }
}


# create all subnets for the infra vnet, workstation /25 , server /25
module "infra_subnet" {
  source    = "../../modules/subnet"
  common    = local.common
  vnet_name = module.vnets.vnet_name_name["infra-vnet"]

  subnet = {
    wks : {
      cidr              = [local.common.cidr.subnet.use.subnet_infra[0]]
      service_endpoints = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.AzureCosmosDB", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.EventHub", "Microsoft.Web", "Microsoft.CognitiveServices"]
    }
    svr : {
      cidr              = [local.common.cidr.subnet.use.subnet_infra[1]]
      service_endpoints = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.AzureCosmosDB", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.EventHub", "Microsoft.Web", "Microsoft.CognitiveServices"]
    }
  }
}


# create all subnets for the pe vnet, pe /25 , reserve /25
module "pe_subnet" {
  source    = "../../modules/subnet"
  common    = local.common
  vnet_name = module.vnets.vnet_name_name["pe-vnet"]

  subnet = {
    pe : {
      cidr              = [local.common.cidr.subnet.use.subnet_pe[0]]
      service_endpoints = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.AzureCosmosDB", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.EventHub", "Microsoft.Web", "Microsoft.CognitiveServices"]
    }
  }
}


# create all subnets for the avd vnet, avd /25 , reserve /25
module "avd_subnet" {
  source    = "../../modules/subnet"
  common    = local.common
  vnet_name = module.vnets.vnet_name_name["avd-vnet"]

  subnet = {
    avd : {
      cidr              = [local.common.cidr.subnet.use.subnet_avd[0]]
      service_endpoints = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.AzureCosmosDB", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.EventHub", "Microsoft.Web", "Microsoft.CognitiveServices"]
    }
  }
}


# bastion nsg
module "bastion_nsg" {
  source   = "../../modules/nsg_cyberlab"
  common   = local.common
  nsg_name = "bas-nsg"
}

# default nsg for all subnets
module "default_nsg" {
  source   = "../../modules/nsg_default"
  common   = local.common
  nsg_name = "default-nsg"
}


# Assign NSG to all subnet in the vnet
module "nsg_assc" {
  source = "../../modules/nsg_subnet_assc"
  nsg_subnet = {
    bas : {
      nsg_id    = module.bastion_nsg.nsg_name_id["bas-nsg"]
      subnet_id = module.fw_subnet.subnet_name_id["AzureBastionSubnet"]
    }
    infra_wks : {
      nsg_id    = module.default_nsg.nsg_name_id["default-nsg"]
      subnet_id = module.infra_subnet.subnet_name_id["wks"]
    }
    infra_svr : {
      nsg_id    = module.default_nsg.nsg_name_id["default-nsg"]
      subnet_id = module.infra_subnet.subnet_name_id["svr"]
    }
    pe : {
      nsg_id    = module.default_nsg.nsg_name_id["default-nsg"]
      subnet_id = module.pe_subnet.subnet_name_id["pe"]
    }
    avd : {
      nsg_id    = module.default_nsg.nsg_name_id["default-nsg"]
      subnet_id = module.avd_subnet.subnet_name_id["avd"]
    }
  }
}




# fw peer to others
locals {
  local_vnpeer_do = true
  name_id_map1    = module.vnets.*.vnet_name_and_id_map[0]
  name_list1      = module.vnet.*.vnet_name_list[0]
}

module "fw_to_vnet" {
  count            = local.local_vnpeer_do ? 1 : 0
  source           = "../../modules/vnp_mesh"
  common           = local.common
  vnet_name_id_map = local.name_id_map1
  vnet_name_list   = local.name_list1
}

# all other vnet peer to fw
locals {
  name_id_map2 = module.vnet.*.vnet_name_and_id_map[0]
  name_list2   = module.vnets.*.vnet_name_list[0]
}

module "vnet_to_fw" {
  count            = local.local_vnpeer_do ? 1 : 0
  source           = "../../modules/vnp_mesh"
  common           = local.common
  vnet_name_id_map = local.name_id_map2
  vnet_name_list   = local.name_list2
}


# route table for vnet
module "rtb" {
  source = "../../modules/rtb"
  common = local.common
  rtb = {
    vnet : {
      name = "default-to-afw-rtb"
      route = {
        default : {
          name          = "default"
          prefix        = "0.0.0.0/0"
          next_hop_type = "VirtualAppliance"
          next_hop_ip   = local.fw_ip
        }
      }
    }

  }
}

# associcate subnet to route table
module "rtb_subnet_assc" {
  source = "../../modules/rtb_subnet_assc"
  rtb_subnet = {
    wks : {
      rtb_id    = module.rtb.rtb_name_id["default-to-afw-rtb"]
      subnet_id = module.infra_subnet.subnet_name_id["wks"]
    }
    svr : {
      rtb_id    = module.rtb.rtb_name_id["default-to-afw-rtb"]
      subnet_id = module.infra_subnet.subnet_name_id["svr"]
    }
    pe : {
      rtb_id    = module.rtb.rtb_name_id["default-to-afw-rtb"]
      subnet_id = module.pe_subnet.subnet_name_id["pe"]
    }
    avd : {
      rtb_id    = module.rtb.rtb_name_id["default-to-afw-rtb"]
      subnet_id = module.avd_subnet.subnet_name_id["avd"]
    }
  }
}


locals {
  hub_ready = true
}

# get all vnc id for all regions
module "vnc_id" {
  source    = "../../modules/vnc_id"
  fw_vnc_id = local.fw_vnc_id
}

# add route into vhub route table
module "default_vrtb_rt" {
  count          = local.hub_ready ? 1 : 0
  source         = "../../modules/vrtb_route"
  route_table_id = local.default_vrtb_id
  route = {
    use-summary-route : {
      dest_type = "CIDR"
      dst_list  = local.common.cidr.all.cidr_use
      hop_type  = "ResourceId"
      next_hop  = module.vnc_id.vnc_id.use_vnc_id
    }
    use2-summary-route : {
      dest_type = "CIDR"
      dst_list  = local.common.cidr.all.cidr_use2
      hop_type  = "ResourceId"
      next_hop  = module.vnc_id.vnc_id.use2_vnc_id
    }
    aen-summary-route : {
      dest_type = "CIDR"
      dst_list  = local.common.cidr.all.cidr_aen
      hop_type  = "ResourceId"
      next_hop  = module.vnc_id.vnc_id.aen_vnc_id
    }
    uks-summary-route : {
      dest_type = "CIDR"
      dst_list  = local.common.cidr.all.cidr_uks
      hop_type  = "ResourceId"
      next_hop  = module.vnc_id.vnc_id.uks_vnc_id
    }
    ase-summary-route : {
      dest_type = "CIDR"
      dst_list  = local.common.cidr.all.cidr_ase
      hop_type  = "ResourceId"
      next_hop  = module.vnc_id.vnc_id.ase_vnc_id
    }
    asse-summary-route : {
      dest_type = "CIDR"
      dst_list  = local.common.cidr.all.cidr_asse
      hop_type  = "ResourceId"
      next_hop  = module.vnc_id.vnc_id.asse_vnc_id
    }
    aue-summary-route : {
      dest_type = "CIDR"
      dst_list  = local.common.cidr.all.cidr_aue
      hop_type  = "ResourceId"
      next_hop  = module.vnc_id.vnc_id.aue_vnc_id
    }
    brs-summary-route : {
      dest_type = "CIDR"
      dst_list  = local.common.cidr.all.cidr_brs
      hop_type  = "ResourceId"
      next_hop  = module.vnc_id.vnc_id.brs_vnc_id
    }
    dec-summary-route : {
      dest_type = "CIDR"
      dst_list  = local.common.cidr.all.cidr_dec
      hop_type  = "ResourceId"
      next_hop  = module.vnc_id.vnc_id.dec_vnc_id
    }
    jpe-summary-route : {
      dest_type = "CIDR"
      dst_list  = local.common.cidr.all.cidr_jpe
      hop_type  = "ResourceId"
      next_hop  = module.vnc_id.vnc_id.jpe_vnc_id
    }
    cac-summary-route : {
      dest_type = "CIDR"
      dst_list  = local.common.cidr.all.cidr_cac
      hop_type  = "ResourceId"
      next_hop  = module.vnc_id.vnc_id.cac_vnc_id
    }

  }

}


# remote vnet peering - run after the remote vnet get created first
# only if remote_vnpeer_do is set to true

locals {
  remote_vnpeer_do = true
}


# data call to get use sec vnet
data "azurerm_virtual_network" "vnet_r" {
  count               = local.remote_vnpeer_do ? 1 : 0
  name                = "prod-use-sec-vnet01"
  resource_group_name = "prod-use-sec-rg01"
  provider            = azurerm.sec
}

locals {
  name_id_map3 = local.remote_vnpeer_do ? { "${data.azurerm_virtual_network.vnet_r[0].name}" = data.azurerm_virtual_network.vnet_r[0].id } : null
  name_list3   = module.vnet.*.vnet_name_list[0]
}

module "vnet_peering_fw" {
  count            = local.remote_vnpeer_do ? 1 : 0
  source           = "../../modules/vnp_mesh"
  common           = local.common
  vnet_name_id_map = local.name_id_map3
  vnet_name_list   = local.name_list3
}



# get Log Workspace data
data "azurerm_log_analytics_workspace" "log" {
  name                = "prod-use-cyber-logworkspace"
  resource_group_name = "loganalyticsworkspacerg"
  provider            = azurerm.prod
}

data "azurerm_storage_account" "sa" {
  name                = "prodcybersharedseclogs"
  resource_group_name = "GRID-CYBER-INFRA-SHARED-SEC"
  provider            = azurerm.sec
}

# fw diagastic setting, send log to log wks
module "diag_set" {
  source                         = "../../modules/diag_set"
  common                         = local.common
  name                           = "${module.fw.fw_name}-diag-setting"
  target_id                      = module.fw.fw_id
  sa_id                          = data.azurerm_storage_account.sa.id
  eh_name                        = null
  la_wks_id                      = data.azurerm_log_analytics_workspace.log.id
  log_analytics_destination_type = "AzureDiagnostics"

  log = {
    log1 : {
      log_cat     = "AzureFirewallApplicationRule"
      log_enable  = true
      logr_enable = true
      logr_days   = 90
    }

    log2 : {
      log_cat     = "AzureFirewallDnsProxy"
      log_enable  = true
      logr_enable = true
      logr_days   = 90
    }

    log3 : {
      log_cat     = "AzureFirewallNetworkRule"
      log_enable  = true
      logr_enable = true
      logr_days   = 90
    }

  }
  metric = {
    m1 : {
      m_cat     = "AllMetrics"
      m_enable  = false
      mr_enable = false
      mr_days   = 0
    }
  }
}



# data call to get ipsec key
data "azurerm_key_vault" "kv" {
  name                = "prod-use-tfstate-key"
  resource_group_name = "cyberlabs-prod-network-tfstate"
}

data "azurerm_key_vault_secret" "key" {
  name         = "sec-link-ipsec-key"
  key_vault_id = data.azurerm_key_vault.kv.id
}


# create vpn gateway
module "vpngw" {
  source     = "../../modules/vpngw"
  common     = local.common
  name       = "vpngw"
  vhub_id    = module.vhub.vhub_id
  scale_unit = 4
}


# define VPN site 
module "vpnsite_1" {
  source  = "../../modules/vpnsite"
  common  = local.common
  name    = "sec-vst"
  vwan_id = module.vwan.vwan_id
  link = {
    link1 : {
      link_name = "link1"
      remote_ip = local.common.cidr.vpn.sec[0][0]
      bgp = {
        bgp1 : {
          bgp_asn = local.common.cidr.vpn.sec[2]
          peer_ip = split("/", local.common.cidr.vpn.sec[0][1])[0]
        }
      }
    }
  }
  site_prefix_list = [local.common.cidr.vpn.sec[0][1]]
}

# define VPN connection and IPSEC info
module "vpngw_conn_1" {
  source     = "../../modules/vpngw_conn"
  common     = local.common
  name       = "sec-conn"
  vpngw_id   = module.vpngw.vpngw_id
  vpnsite_id = module.vpnsite_1.vpnsite_id

  vpn_link = {
    link1 : {
      link_name           = "link1"
      link_id             = module.vpnsite_1.vpnsite_link1_id
      link_ipsec_key      = data.azurerm_key_vault_secret.key.value
      enable_bgp          = true
      policy_based_enable = false
      ipsec_policy = {
        policy1 : {
          dh_group         = "ECP384"
          ike_encryption   = "GCMAES256"
          ike_integrity    = "SHA384"
          ipsec_encryption = "GCMAES256"
          ipsec_integrity  = "GCMAES256"
          pfs_group        = "ECP384"
          sa_data_size_kb  = 102400000
          sa_lifetime_sec  = 27000
        }
      }
    }
  }

  routing = null

  traffic_selector_policy = null

}


data "azurerm_key_vault_secret" "use_key" {
  name         = "use-link-ipsec-key"
  key_vault_id = data.azurerm_key_vault.kv.id
}


# define VPN site 
module "vpnsite_2" {
  source  = "../../modules/vpnsite"
  common  = local.common
  name    = "use-vst"
  vwan_id = module.vwan.vwan_id
  link = {
    link1 : {
      link_name = "link1"
      remote_ip = "13.68.240.226"
      bgp = {
        bgp1 : {
          bgp_asn = 65700
          peer_ip = "172.30.0.62"
        }
      }
    }
  }
  site_prefix_list = ["172.30.0.62/32"]
}

# define VPN connection and IPSEC info
module "vpngw_conn_2" {
  source     = "../../modules/vpngw_conn"
  common     = local.common
  name       = "use-conn"
  vpngw_id   = module.vpngw.vpngw_id
  vpnsite_id = module.vpnsite_2.vpnsite_id

  vpn_link = {
    link1 : {
      link_name           = "link1"
      link_id             = module.vpnsite_2.vpnsite_link1_id
      link_ipsec_key      = data.azurerm_key_vault_secret.use_key.value
      enable_bgp          = true
      policy_based_enable = false
      ipsec_policy = {
        policy1 : {
          dh_group         = "ECP384"
          ike_encryption   = "GCMAES256"
          ike_integrity    = "SHA384"
          ipsec_encryption = "GCMAES256"
          ipsec_integrity  = "GCMAES256"
          pfs_group        = "ECP384"
          sa_data_size_kb  = 102400000
          sa_lifetime_sec  = 27000
        }
      }
    }
  }

  routing = null

  traffic_selector_policy = null

}


###################################  TEST VM

module "vm1" {
  source    = "../../modules/vm"
  common    = local.common
  vm_name   = "wks-ubuntu"
  nic_name  = "wks-ubuntu-nic"
  ip_name   = "wks-ubuntu-ip"
  subnet_id = module.infra_subnet.subnet_name_id["wks"]
}

module "vm2" {
  source    = "../../modules/vm"
  common    = local.common
  vm_name   = "svr-ubuntu"
  nic_name  = "svr-ubuntu-nic"
  ip_name   = "svr-ubuntu-ip"
  subnet_id = module.infra_subnet.subnet_name_id["svr"]
}

*/