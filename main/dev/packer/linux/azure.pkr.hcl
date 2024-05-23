locals {
  location     = "East US"
  rsg_name     = "dev-use-lab-rg"
  img_name     = "eve-ng"
  gallery_name = "image_gallery"
  img_ver      = "1.0.0"
  img_name_v   = "${local.img_name}-${local.img_ver}"
}

source "azure-arm" "dev_arm" {
  subscription_id = var.dev_subscription_id
  client_id       = var.spn-client-id
  client_secret   = var.spn-client-secret
  tenant_id       = var.spn-tenant-id

  location                          = local.location
  managed_image_name                = local.img_name
  managed_image_resource_group_name = local.rsg_name

  communicator    = "ssh"
  os_type         = "Linux"
  image_offer     = "0001-com-ubuntu-server-jammy"
  image_publisher = "Canonical"
  image_sku       = "22_04-lts-gen2"
  vm_size         = "Standard_DS3_v2"

  # enable only if run from my PC
  #allowed_inbound_ip_addresses = ["72.83.43.168"]

  shared_image_gallery_destination {
    subscription         = var.dev_subscription_id
    resource_group       = local.rsg_name
    gallery_name         = local.gallery_name
    image_name           = local.img_name
    image_version        = local.img_ver
    storage_account_type = "Standard_LRS"
    target_region {
      name = local.location
    }
  }
}


