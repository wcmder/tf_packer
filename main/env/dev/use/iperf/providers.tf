terraform {
  required_version = ">= 1.14.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.66.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.dev_subscription_id
  client_id       = var.spn-client-id
  client_secret   = var.spn-client-secret
  tenant_id       = var.spn-tenant-id
}
