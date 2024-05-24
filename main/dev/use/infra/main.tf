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


output "common" {
  value = local.common.cidr
}


# share image gallery
module "sig" {
  source = "../../../modules/system/sig"
  common = local.common
  name   = "image_gallery"
}

# eve ng img
module "sig_img_eveng" {
  source    = "../../../modules/system/sig_img"
  common    = local.common
  img_name  = "eve-ng"
  sig_name  = module.sig.sig_name
  os_type   = "Linux"
  publisher = "wder"
  offer     = "UbutunServer"
  sku       = "jammy-eve-ng"

  depends_on = [
    module.sig
  ]
}

# storage account
module "sa01" {
  source   = "../../../modules/system/sa"
  common   = local.common
  name     = "sa01"
  act_tier = "Premium"
  act_type = "LRS"
}

# sa container
module "sa01_container" {
  source  = "../../../modules/system/sa_container"
  common  = local.common
  name    = "container01"
  sa_name = module.sa01.sa_name
  #access_type = "blob"
}

# sa container blob to store the image version
module "sa01_blob" {
  source         = "../../../modules/system/sa_blob"
  common         = local.common
  name           = "blob01"
  sa_name        = module.sa01.sa_name
  container_name = module.sa01_container.container_name
  type           = "Block"
}

# eve ng image version
module "sig_img_ver_010" {
  source   = "../../../modules/system/sig_img_ver"
  common   = local.common
  ver      = "0.1.0"
  img_name = "eve-ng"
  sig_name = module.sig.sig_name
  blob_uri = module.sa01_blob.blob_url
  sa_id    = module.sa01.sa_id

  depends_on = [
    module.sig,
    module.sig_img_eveng,
    module.sa01_blob
  ]
}


/*
# create lab vnet
module "vnet" {
  source = "../../../modules/network/vnet"
  common = local.common
  vnet = {
    "lab-vnet" : [local.common.cidr.vnet.use.vnet_lab, []]
  }
}

# create all subnets for the fw vnet, fw /26 , mgmt /26, bastion /26
module "subnet_lab" {
  source    = "../../../modules/network/subnet"
  common    = local.common
  vnet_name = module.vnet.vnet_name_name["lab-vnet"]

  subnet = {
    vm-subnet : {
      cidr = local.common.cidr.subnet.use.vnet_lab.subnet_lab_vm
    }
    AzureBastionSubnet : {
      cidr = local.common.cidr.subnet.use.vnet_lab.subnet_lab_bastion
    }
  }
}


# default nsg for all subnets
module "default_nsg" {
  source   = "../../../modules/network/nsg_default"
  common   = local.common
  nsg_name = "default-nsg"
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
          name            = "allow_wder_http"
          priority        = 100
          direction       = "Inbound"
          access          = "Allow"
          protocol        = "Tcp"
          src_port_range  = "*"
          dst_port_range  = "80"
          src_addr_prefix = "72.83.43.168"
          dst_addr_prefix = "*"
        }
        rule2 : {
          name            = "allow_wder_ssh"
          priority        = 110
          direction       = "Inbound"
          access          = "Allow"
          protocol        = "Tcp"
          src_port_range  = "*"
          dst_port_range  = "22"
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
module "eveng_pip" {
  source   = "../../../modules/network/pip"
  common   = local.common
  pip_name = "${module.vnet.vnet_name_name["lab-vnet"]}-eveng-pip"
}


module "eve-ng" {
  source      = "../../../modules/system/vm"
  common      = local.common
  vm_name     = "eve-ng"
  nic_name    = "eve-ng-nic"
  ip_name     = "eve-ng-ip"
  subnet_id   = module.subnet_lab.subnet_name_id["vm-subnet"]
  pip_addr_id = module.eveng_pip.pip_id
  vm_size     = "Standard_DS3_v2"
  src_img_id  = module.shared_img.img_id
}
*/
