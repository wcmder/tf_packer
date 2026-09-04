# Azure image builder configuration.
locals {
  location     = "East US"
  rsg_name     = "dev-use-images-rg"
  img_name     = "iperf"
  gallery_name = "image_gallery"
}

source "azure-arm" "dev_arm" {
  subscription_id = var.dev_subscription_id
  client_id       = var.spn-client-id
  client_secret   = var.spn-client-secret
  tenant_id       = var.spn-tenant-id

  location = local.location

  shared_image_gallery_destination {
    subscription         = var.dev_subscription_id
    resource_group       = local.rsg_name
    gallery_name         = local.gallery_name
    image_name           = local.img_name
    image_version        = var.iperf_image_version
    storage_account_type = "Standard_LRS"

    target_region {
      name     = local.location
      replicas = 1
    }
  }

  shared_image_gallery_timeout = "2h"

  communicator    = "ssh"
  os_type         = "Linux"
  image_offer     = "0001-com-ubuntu-server-jammy"
  image_publisher = "Canonical"
  image_sku       = "22_04-lts-gen2"
  image_version   = var.ubuntu_image_version
  vm_size         = "Standard_D4s_v5"
  os_disk_size_gb = 64

  # enable only if run from my PC
  #allowed_inbound_ip_addresses = ["72.83.43.168"]
}
