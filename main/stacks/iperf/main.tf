module "context" {
  source = "../context"

  env      = var.environment
  reg      = var.location
  svc_name = var.service_name
}

module "rsg" {
  source = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/network/rsg?ref=v0.1.1"

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
  source = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/network/vnet?ref=v0.1.1"
  common = local.common
  vnet = {
    vm-vnet = {
      address_space_list = local.common.cidr.vnet.use.vnet_lab
      dns_server_list    = []
    }
  }
}

module "subnet_lab" {
  source    = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/network/subnet?ref=v0.1.1"
  common    = local.common
  vnet_name = module.vnet.vnet_name_name["vm-vnet"]
  subnet = {
    vm-subnet = {
      cidr_list = local.common.cidr.subnet.use.vnet_lab.subnet_lab_vm
    }
    AzureBastionSubnet = {
      cidr_list = local.common.cidr.subnet.use.vnet_lab.subnet_lab_bastion
    }
  }
}

module "bastion_nsg" {
  source   = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/network/nsg_bas?ref=v0.1.1"
  common   = local.common
  nsg_name = "bas-nsg"
}

module "iperf_nsg" {
  source = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/network/nsg?ref=v0.1.1"
  common = local.common
  nsg = {
    iperf_nsg = {
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
  source = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/network/nsg_subnet_assc?ref=v0.1.1"
  nsg_subnet = {
    bas = {
      nsg_id    = module.bastion_nsg.nsg_name_id["bas-nsg"]
      subnet_id = module.subnet_lab.subnet_name_id["AzureBastionSubnet"]
    }
    vm = {
      nsg_id    = module.iperf_nsg.nsg_name_id["iperf_nsg"]
      subnet_id = module.subnet_lab.subnet_name_id["vm-subnet"]
    }
  }
}

module "iperf_pip" {
  source = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/network/pip?ref=v0.1.1"
  common = local.common
  pip = {
    vm-vnet-iperf-pip = {}
  }
}

data "azurerm_image" "iperf" {
  name                = "iperf-0.1.2"
  resource_group_name = local.common.rsg_name
}

module "iperf-vm" {
  source      = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/system/vm?ref=v0.1.1"
  common      = local.common
  vm_name     = "iperf-vm"
  nic_name    = "iperf-nic"
  ip_name     = "iperf-ip"
  subnet_id   = module.subnet_lab.subnet_name_id["vm-subnet"]
  pip_addr_id = module.iperf_pip.pip_name_id["vm-vnet-iperf-pip"]
  vm_size     = "Standard_D8s_v3"
  src_img_id  = data.azurerm_image.iperf.id
}
