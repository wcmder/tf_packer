module "sig" {
  source = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/system/sig?ref=v0.1.1"
  common = local.common
  name   = "image_gallery"
}

locals {
  image_versions = {
    "0.1.0" = {
      image_name = "eve-ng-0.1.0"
      sku        = "jammy-eve-ng1"
    }
    "0.1.1" = {
      image_name = "eve-ng-0.1.1"
      sku        = "jammy-eve-ng2"
    }
  }
}

module "sig_img" {
  for_each = local.image_versions
  source   = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/system/sig_img?ref=v0.1.1"

  common    = local.common
  img_name  = each.value.image_name
  sig_name  = module.sig.sig_name
  os_type   = "Linux"
  publisher = "wder"
  offer     = "UbutunServer"
  sku       = each.value.sku
}

data "azurerm_image" "managed" {
  for_each = local.image_versions

  name                = each.value.image_name
  resource_group_name = local.common.rsg_name
}

module "sig_img_ver" {
  for_each = local.image_versions
  source   = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/system/sig_img_ver?ref=v0.1.1"

  common     = local.common
  ver        = each.key
  img_name   = each.value.image_name
  sig_name   = module.sig.sig_name
  mgn_img_id = data.azurerm_image.managed[each.key].id

  depends_on = [module.sig_img]
}
