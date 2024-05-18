# create or get resource group and subscription information
# main = true creates the resouce group and info
# main = false gets the info only


module "main" {
  source       = "../../modules/main_demo"
  main         = true
  rsg_name     = "rg01"
  rsg_location = "East US"
  reg          = "East US"
  evn          = "dev"
  svc_name     = "lab1"
}


# pass into module call
locals {
  common = module.main.common
}
