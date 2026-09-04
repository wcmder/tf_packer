terraform {
  backend "azurerm" {
    subscription_id      = "3ee28fc2-7a0e-46c8-b38d-14ca6a26d742"
    resource_group_name  = "dostest01"
    storage_account_name = "dostest01sa01"
    container_name       = "tfstate01"
    key                  = "tfp-images.tfstate"
  }
}
