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
  subscription_id = "3ee28fc2-7a0e-46c8-b38d-14ca6a26d742"
  client_id       = var.spn-client-id
  client_secret   = var.spn-client-secret
  tenant_id       = var.spn-tenant-id
  alias           = "prod"
}


provider "azurerm" {
  features {}
  subscription_id = "57cd861e-6e61-4d90-ad57-799cd9f5d1a9"
  client_id       = var.spn-client-id
  client_secret   = var.spn-client-secret
  tenant_id       = var.spn-tenant-id
}
