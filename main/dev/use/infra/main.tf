# create or get resource group and subscription information
# main = true creates the resouce group and info
# main = false gets the info only


module "main" {
  source       = "../../../modules/org"
  main         = true
  rsg_name     = "rg"
  rsg_location = "East US"
  reg          = "East US"
  env          = "dev"
  svc_name     = "lab"
}


# pass into module call
locals {
  common = module.main.common
}

