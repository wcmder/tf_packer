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
  img_name         = "eve-ng-1.0.0"
  img_gallery_name = module.img_gallery.img_gallery_name
  os_type          = "Linux"
  publisher        = "wder"
  offer            = "UbutunServer"
  sku              = "jammy"

}
