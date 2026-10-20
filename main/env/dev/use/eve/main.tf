/*
module "eve" {
  source = "../../../../stacks/eve"

  vm_admin_username = var.vm_admin_username
  vm_admin_password = var.vm_admin_password

  environment          = "dev"
  location             = "East US"
  service_name         = "lab"
  resource_group_name  = "rg"
  eve_image_version    = var.eve_image_version
  vpn_client_tenant_id = var.spn-tenant-id
}

*/

module "eve_wg" {
  source = "../../../../stacks/eve_wg"

  vm_admin_username = var.vm_admin_username
  vm_admin_password = var.vm_admin_password

  environment         = "dev"
  location            = "East US"
  service_name        = "lab"
  resource_group_name = "rg"
  eve_image_version   = var.eve_image_version

  wireguard_peers = {
    macbook = {
      public_key = "MI64Bvb9JZyOWzomKspmrNHvsPRVmnTOR7O2VIN5A3E="
      address    = "172.16.0.2/32"
    }
  }
}
