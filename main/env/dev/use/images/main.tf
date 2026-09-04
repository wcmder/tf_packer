module "images" {
  source = "../../../../stacks/images"

  environment         = "dev"
  location            = "East US"
  service_name        = "images"
  resource_group_name = "rg"
}
