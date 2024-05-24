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

module "img_gallery" {
  source = "../../../modules/system/img_gallery"
  common = local.common
  name   = "image_gallery"
}

module "shared_img" {
  source           = "../../../modules/system/shared_img"
  common           = local.common
  img_name         = "eve-ng"
  img_gallery_name = module.img_gallery.img_gallery_name
  os_type          = "Linux"
  publisher        = "wder"
  offer            = "UbutunServer"
  sku              = "jammy-eve-ng"
}

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

