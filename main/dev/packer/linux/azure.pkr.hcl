locals {
  location     = "East US"
  rsg_name     = "dev-use-lab-rg"
  img_name     = "eve-ng"
  gallery_name = "image_gallery"
  img_name_v   = "${local.img_name}-${local.img_ver}"
  # 0.1.3 - 8kv palo, no desktop no xrdp
  img_ver = "0.1.4"
}

source "azure-arm" "dev_arm" {
  subscription_id = var.dev_subscription_id
  client_id       = var.spn-client-id
  client_secret   = var.spn-client-secret
  tenant_id       = var.spn-tenant-id

  location                          = local.location
  managed_image_name                = local.img_name_v
  managed_image_resource_group_name = local.rsg_name

  communicator    = "ssh"
  os_type         = "Linux"
  image_offer     = "0001-com-ubuntu-server-jammy"
  image_publisher = "Canonical"
  image_sku       = "22_04-lts-gen2"
  vm_size         = "Standard_D8s_v3"

  # enable only if run from my PC
  #allowed_inbound_ip_addresses = ["72.83.43.168"]
}


