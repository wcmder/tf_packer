# create or get resource group and subscription information
# main = true creates the resouce group and info
# main = false gets the info only


module "main" {
  source       = "../../../modules/org"
  main         = true
  rsg_name     = "rg"
  rsg_location = "East US"
  reg          = "East US"
  env          = "dev"
  svc_name     = "lab"
}


# pass into module call
locals {
  common = module.main.common
}



# create lab vnet
module "vnet" {
  source = "../../../modules/network/vnet"
  common = local.common
  vnet = {
    "vm-vnet" : [local.common.cidr.vnet.use.vnet_lab, []]
  }
}

# create all subnets for the fw vnet, fw /26 , mgmt /26, bastion /26
module "subnet_lab" {
  source    = "../../../modules/network/subnet"
  common    = local.common
  vnet_name = module.vnet.vnet_name_name["vm-vnet"]

  subnet = {
    vm-subnet : {
      cidr = local.common.cidr.subnet.use.vnet_lab.subnet_lab_vm
    }
    AzureBastionSubnet : {
      cidr = local.common.cidr.subnet.use.vnet_lab.subnet_lab_bastion
    }
  }
}


# bastion nsg
module "bastion_nsg" {
  source   = "../../../modules/network/nsg_bas"
  common   = local.common
  nsg_name = "bas-nsg"
}

# Create NSG
module "eveng_nsg" {
  source = "../../../modules/network/nsg"
  common = local.common
  nsg = {

    nsg1 : {
      nsg_name = "eveng_nsg"
      security_rule = {
        rule1 : {
          name            = "allow_wder"
          priority        = 100
          direction       = "Inbound"
          access          = "Allow"
          protocol        = "Tcp"
          src_port_range  = "*"
          dst_port_range  = "*"
          src_addr_prefix = "72.83.43.168"
          dst_addr_prefix = "*"
        }
      }
    }

  }
}


# Assign NSG to all subnet in the vnet
module "nsg_assc" {
  source = "../../../modules/network/nsg_subnet_assc"
  nsg_subnet = {
    bas : {
      nsg_id    = module.bastion_nsg.nsg_name_id["bas-nsg"]
      subnet_id = module.subnet_lab.subnet_name_id["AzureBastionSubnet"]
    }
    vm : {
      nsg_id    = module.eveng_nsg.nsg_name_id["eveng_nsg"]
      subnet_id = module.subnet_lab.subnet_name_id["vm-subnet"]
    }
  }
}


#  public IP
module "eveng1_pip" {
  source   = "../../../modules/network/pip"
  common   = local.common
  pip_name = "${module.vnet.vnet_name_name["vm-vnet"]}-eveng1-pip"
}


# get imag id
data "azurerm_image" "eveng1" {
  name                = "eve-ng-0.1.4"
  resource_group_name = local.common.rsg_name
}


############################## VMs:
/*
# eve ng VM 1
module "eve-ng1-vm" {
  source      = "../../../modules/system/vm"
  common      = local.common
  vm_name     = "eveng1-vm"
  nic_name    = "eveng1-nic"
  ip_name     = "eveng1-ip"
  subnet_id   = module.subnet_lab.subnet_name_id["vm-subnet"]
  pip_addr_id = module.eveng1_pip.pip_id
  vm_size     = "Standard_D8s_v3"
  src_img_id  = data.azurerm_image.eveng1.id
}
*/

