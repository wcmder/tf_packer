module "context" {
  source = "../context"

  env      = var.environment
  reg      = var.location
  svc_name = var.service_name
}

module "rsg" {
  source = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/network/rsg?ref=v0.1.5"

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

module "sig" {
  source = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/system/sig?ref=v0.1.5"
  common = local.common
  name   = "image_gallery"
}

module "sig_img_eve" {
  source = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/system/sig_img?ref=v0.1.5"

  common    = local.common
  img_name  = "eve-ng"
  sig_name  = module.sig.sig_name
  os_type   = "Linux"
  publisher = "dkn"
  offer     = "UbuntuServer"
  sku       = "jammy-eve-ng"

  depends_on = [module.sig]
}

module "sig_img_iperf" {
  source = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/system/sig_img?ref=v0.1.5"

  common    = local.common
  img_name  = "iperf"
  sig_name  = module.sig.sig_name
  os_type   = "Linux"
  publisher = "dkn"
  offer     = "UbuntuServer"
  sku       = "jammy-iperf"

  depends_on = [module.sig]
}
