# Azure image builder configuration.
locals {
  img_name = "iperf"
}

source "azure-arm" "arm" {
  subscription_id = var.subscription_id
  client_id       = var.spn-client-id
  client_secret   = var.spn-client-secret
  tenant_id       = var.spn-tenant-id

  location = var.location

  shared_image_gallery_destination {
    subscription         = var.subscription_id
    resource_group       = var.image_resource_group
    gallery_name         = var.gallery_name
    image_name           = local.img_name
    image_version        = var.iperf_image_version
    storage_account_type = "Standard_LRS"

    target_region {
      name     = var.location
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
