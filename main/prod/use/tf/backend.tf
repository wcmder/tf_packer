
terraform {
  backend "azurerm" {
    subscription_id      = var.prod_subscription_id
    resource_group_name  = "dostest01"
    storage_account_name = "dostest01sa01"
    container_name       = "tfstate01"
    key                  = "tfp-01.tfstate"
  }
}

