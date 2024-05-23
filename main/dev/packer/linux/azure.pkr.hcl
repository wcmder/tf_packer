source "azure-arm" "dev_arm" {
  subscription_id = var.dev_subscription_id
  client_id       = var.spn-client-id
  client_secret   = var.spn-client-secret
  tenant_id       = var.spn-tenant-id

  location                          = "East US"
  managed_image_name                = "evn-ng"
  managed_image_resource_group_name = "dev-use-lab-rg"

  communicator    = "ssh"
  os_type         = "Linux"
  image_offer     = "0001-com-ubuntu-server-jammy"
  image_publisher = "Canonical"
  image_sku       = "22_04-lts-gen2"
  vm_size         = "Standard_DS3_v2"

  allowed_inbound_ip_addresses = ["72.83.43.168", "72.83.43.170"]

}


