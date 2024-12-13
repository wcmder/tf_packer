# Gallery, Image and Version

/*
# share image gallery
module "sig" {
  source = "../../../modules/system/sig"
  common = local.common
  name   = "image_gallery"
}


locals {
  ver010    = "0.1.0"
  ver011    = "0.1.1"
  img_name1 = "eve-ng-${local.ver010}"
  img_name2 = "eve-ng-${local.ver011}"
  sku1      = "jammy-eve-ng1"
  sku2      = "jammy-eve-ng2"
}

############################## ver 0.1.0 BEGIN
# eve ng img defintion 
module "sig_img_eveng1" {
  source    = "../../../modules/system/sig_img"
  common    = local.common
  img_name  = local.img_name1
  sig_name  = module.sig.sig_name
  os_type   = "Linux"
  publisher = "wder"
  offer     = "UbutunServer"
  sku       = local.sku1

  depends_on = [
    module.sig
  ]
}

# get imag id
data "azurerm_image" "eveng1" {
  name                = local.img_name1
  resource_group_name = local.common.rsg_name
}


# eve ng image version
module "sig_img_ver_010" {
  source     = "../../../modules/system/sig_img_ver"
  common     = local.common
  ver        = local.ver010
  img_name   = local.img_name1
  sig_name   = module.sig.sig_name
  mgn_img_id = data.azurerm_image.eveng1.id

  depends_on = [
    module.sig,
    module.sig_img_eveng1,
  ]
}

############################## ver 0.1.0 END


############################## ver 0.1.1 BEGIN
# eve ng img defintion 
module "sig_img_eveng2" {
  source    = "../../../modules/system/sig_img"
  common    = local.common
  img_name  = local.img_name2
  sig_name  = module.sig.sig_name
  os_type   = "Linux"
  publisher = "wder"
  offer     = "UbutunServer"
  sku       = local.sku2

  depends_on = [
    module.sig
  ]
}

# get imag id
data "azurerm_image" "eveng2" {
  name                = local.img_name2
  resource_group_name = local.common.rsg_name
}


# eve ng image version
module "sig_img_ver_011" {
  source     = "../../../modules/system/sig_img_ver"
  common     = local.common
  ver        = local.ver011
  img_name   = local.img_name2
  sig_name   = module.sig.sig_name
  mgn_img_id = data.azurerm_image.eveng2.id
}

############################## ver 0.1.1 END
*/
