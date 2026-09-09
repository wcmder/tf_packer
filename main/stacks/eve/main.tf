module "context" {
  source = "../context"

  env      = var.environment
  reg      = var.location
  svc_name = var.service_name
}
module "rsg" {
  source = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/network/rsg?ref=v0.1.6"

  common = module.context.common
  rsg = {
    (var.resource_group_name) = {
      rsg_location = var.location
    }
  }
}

locals {
  common = merge(module.context.common, {
    rsg_name     = module.rsg.rsg_name_name[var.resource_group_name]
    rsg_location = module.rsg.rsg_name_location[var.resource_group_name]
  })
}

module "vnet" {
  source = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/network/vnet?ref=v0.1.6"
  common = local.common
  vnet = {
    vm-vnet = {
      address_space_list = local.common.cidr.vnet.use.vnet_lab
      dns_server_list    = []
    }
  }
}

module "subnet_lab" {
  source    = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/network/subnet?ref=v0.1.6"
  common    = local.common
  vnet_name = module.vnet.vnet_name_name["vm-vnet"]
  subnet = {
    vm-subnet = {
      cidr_list = local.common.cidr.subnet.use.vnet_lab.subnet_lab_vm
    }
    GatewaySubnet = {
      cidr_list = local.common.cidr.subnet.use.vnet_lab.subnet_lab_gw
    }
  }
}

module "eveng_nsg" {
  source = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/network/nsg?ref=v0.1.6"
  common = local.common
  nsg = {
    eveng_nsg = {
      security_rule = {
        allow_wder = {
          priority        = 100
          direction       = "Inbound"
          access          = "Allow"
          protocol        = "Tcp"
          src_port_range  = "*"
          dst_port_range  = "*"
          src_addr_prefix = "*"
          dst_addr_prefix = "*"
        }
      }
    }
  }
}

module "nsg_assc" {
  source = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/network/nsg_subnet_assc?ref=v0.1.6"
  nsg_subnet = {
    vm = {
      nsg_id    = module.eveng_nsg.nsg_name_id["eveng_nsg"]
      subnet_id = module.subnet_lab.subnet_name_id["vm-subnet"]
    }
  }
}

module "vngw_pip" {
  source = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/network/pip?ref=v0.1.6"
  common = local.common
  pip = {
    vngw-pip = {
      zones = ["1", "2", "3"]
    }
  }
}

module "vngw" {
  source = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/network/vngw?ref=v0.1.8"
  common = local.common
  name   = "vngw"

  type          = "Vpn"
  vpn_type      = "RouteBased"
  sku           = "VpnGw2AZ"
  generation    = "Generation2"
  active_active = false
  enable_bgp    = false

  custom_route = {
    address_prefixes = ["172.16.1.0/24"]
  }

  ip_configuration = {
    default = {
      gw_pip_id = module.vngw_pip.pip_name_id["vngw-pip"]
      method    = "Dynamic"
      subnet_id = module.subnet_lab.subnet_name_id["GatewaySubnet"]
    }
  }

  vpn_client_configuration = {
    address_space        = ["172.16.0.0/24"]
    aad_tenant           = "https://login.microsoftonline.com/${var.vpn_client_tenant_id}"
    aad_audience         = "c632b3df-fb67-4d84-bdcf-b95ad541b5c8"
    aad_issuer           = "https://sts.windows.net/${var.vpn_client_tenant_id}/"
    vpn_auth_types       = ["AAD"]
    vpn_client_protocols = ["OpenVPN"]
  }
}

module "nested_mgmt_rtb" {
  source = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/network/rtb?ref=v0.1.6"
  common = local.common
  rtb = {
    nested-mgmt-rtb = {
      bgp_route_propagation_enabled = true
      route = {
        nested-mgmt = {
          prefix        = "172.16.1.0/24"
          next_hop_type = "VirtualAppliance"
          next_hop_ip   = module.eve-ng1-vm.private_ip_address
        }
      }
    }
  }
}

module "nested_mgmt_rtb_assc" {
  source = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/network/rtb_subnet_assc?ref=v0.1.6"
  rtb_subnet = {
    gateway = {
      rtb_id    = module.nested_mgmt_rtb.rtb_name_id["nested-mgmt-rtb"]
      subnet_id = module.subnet_lab.subnet_name_id["GatewaySubnet"]
    }
  }
}


data "azurerm_shared_image_version" "eveng_runtime" {
  name                = var.eve_image_version
  image_name          = "eve-ng"
  gallery_name        = "image_gallery"
  resource_group_name = var.image_resource_group_name
}

module "eve-ng1-vm" {
  source                = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/system/vm?ref=v0.1.8"
  common                = local.common
  vm_name               = "eveng1-vm"
  nic_name              = "eveng1-nic"
  ip_name               = "eveng1-ip"
  subnet_id             = module.subnet_lab.subnet_name_id["vm-subnet"]
  ip_forwarding_enabled = true
  #vm_size               = "Standard_D8s_v5"
  vm_size              = "Standard_E8s_v5"
  storage_account_type = "StandardSSD_LRS"
  src_img_id           = data.azurerm_shared_image_version.eveng_runtime.id
}
