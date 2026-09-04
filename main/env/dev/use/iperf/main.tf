module "iperf" {
  source = "../../../../stacks/iperf"

  environment         = "dev"
  location            = "East US"
  service_name        = "iperf"
  resource_group_name = "rg"
  iperf_image_version = var.iperf_image_version
}
