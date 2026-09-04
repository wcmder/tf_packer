module "eve" {
  source = "../../../../stacks/eve"

  environment         = "dev"
  location            = "East US"
  service_name        = "lab"
  resource_group_name = "rg"
}
