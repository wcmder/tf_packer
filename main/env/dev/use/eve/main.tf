module "eve" {
  source = "../../../../stacks/eve"

  environment          = "dev"
  location             = "East US"
  service_name         = "lab"
  resource_group_name  = "rg"
  eve_image_version    = var.eve_image_version
  vpn_client_tenant_id = var.spn-tenant-id
}
