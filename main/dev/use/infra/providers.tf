terraform {
  required_version = ">=1.7.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.103.1"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.prod_subscription_id
  client_id       = var.spn-client-id
  client_secret   = var.spn-client-secret
  tenant_id       = var.spn-tenant-id
  alias           = "prod"
}


provider "azurerm" {
  features {}
  subscription_id = var.dev_subscription_id
  client_id       = var.spn-client-id
  client_secret   = var.spn-client-secret
  tenant_id       = var.spn-tenant-id
}
