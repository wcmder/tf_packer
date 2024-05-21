source "azure-arm" "dev_arm" {
  subscription_id = var.dev_subscription_id
  client_id       = var.spn-client-id
  client_secret   = var.spn-client-secret
  tenant_id       = var.spn-tenant-id
  location        = "East US"
}
