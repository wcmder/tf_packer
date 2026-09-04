locals {
  regions = {
    usgovvirginia = "use"
    eastus        = "use"
    westus        = "usw"
  }

  region_key = replace(lower(var.reg), " ", "")
  region     = local.regions[local.region_key]
  env_prefix = join("-", [var.env, local.region, var.svc_name])

  cidr_all = ["10.0.0.0/21"]
  cidr_region = {
    use_transit = [cidrsubnet(local.cidr_all[0], 1, 0)] # 1st of the /22 from /21
    use_vnet    = [cidrsubnet(local.cidr_all[0], 3, 4)] # 4th of the /24 from /21
  }
  cidr_vnet = {
    use = {
      vnet_vhub = [cidrsubnet(local.cidr_region.use_transit[0], 1, 0)]
      vnet_er   = [cidrsubnet(local.cidr_region.use_transit[0], 2, 2)]
      vnet_lab  = [cidrsubnet(local.cidr_region.use_vnet[0], 1, 0)] # 1st /25
    }
  }
  cidr_subnet = {
    use = {
      vnet_vhub = {
        subnet_vhub = [local.cidr_vnet.use.vnet_vhub[0]]
        er_prim     = [cidrsubnet(local.cidr_vnet.use.vnet_er[0], 6, 0)]
        er_sec      = [cidrsubnet(local.cidr_vnet.use.vnet_er[0], 6, 1)]
      }
      vnet_lab = {
        subnet_lab_vm          = [cidrsubnet(local.cidr_vnet.use.vnet_lab[0], 2, 0)] # 1st /27 from the /25
        subnet_lab_gw          = [cidrsubnet(local.cidr_vnet.use.vnet_lab[0], 2, 1)] # 2nd /27 from the /25
        subnet_lab_nested_mgmt = [cidrsubnet(local.cidr_vnet.use.vnet_lab[0], 1, 1)] # 2nd /26 from the /25
      }
    }
  }

  tags = {
    ApplicationName     = "Network Infrastructure"
    BusinessOwner       = "Wallace"
    InfrastructureOwner = "Wallace"
    Environment         = var.env == "prod" ? "Production" : "Development"
    TechnologyOwner     = "Wallace"
    ApplicationOwner    = "Wallace"
  }

  common = {
    env  = local.env_prefix
    tags = local.tags
    cidr = {
      all    = local.cidr_all
      region = local.cidr_region
      vnet   = local.cidr_vnet
      subnet = local.cidr_subnet
      dns    = ["8.8.8.8"]
    }
    reg = var.reg
  }
}

output "common" {
  description = "Shared naming, tagging, region, and network configuration."
  value       = local.common
}
