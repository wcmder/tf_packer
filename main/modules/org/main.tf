# naming convetion functions
locals {
  # list of region name = avvrivation
  # to be matched from the call, and resulted in list with only the one matched
  region = {
    usgovvirginia = "usgovva"
    eastus        = "use"
  }

  # get region abbrivation for resrouce naming prefix
  # region the resource will be created, this list has only 1 item
  reg_abbr = compact([for k, v in local.region : k == replace(lower(var.reg), " ", "") ? v : ""])

  # get resource group region abbrivation for resrouce naming prefix
  # region of the resource group, this list has only 1 item
  reg_abbr_rsg = compact([for k, v in local.region : k == replace(lower(var.rsg_location), " ", "") ? v : ""])

  # find the rsg region for the module call
  # if true, use reg_abbr in which rsg created in this call
  # if false, use reg_abbr_rsg rsg referenced but not created
  env_rsg = var.main ? join("-", [var.env, local.reg_abbr[0], var.svc_name]) : join("-", [var.env, local.reg_abbr_rsg[0], var.svc_name])
}


# resource name prefix set
/* 
example - $env-$reg_abbr-$svc_name
  prod-usgovva-infra : 
  dev-usgovva-infra
  transit-usgovva-infra
*/
locals {
  #e_name         = var.env
  env          = join("-", [var.env, local.reg_abbr[0], var.svc_name])
  rsg_name     = var.rsg_name
  rsg_location = var.rsg_location
}



# Onprem IP spaces
locals {
  # onprem IP space for static route if used
  cidr_onprem = {
    fs = {
      cidr = ["172.18.0.0/20"]
    }
  }

  # onprem VPN endpoint
  # format [ [ link1-pip, link1-bgp ], [ link2-pip, link2-bgp ], BGP AS #, [ site local address for static routing] ] 
  vpn = {
    fspalo = {
      link1_vpn_ip = "na"
      link1_bgp_ip = "na"
      link2_vpn_ip = "na"
      link2_bgp_ip = "na"
      bgp_asn      = 22238
      local_cidr   = local.cidr_onprem.fs.cidr
    }
  }
}


# list of all DNS servers
locals {
  dns = ["8.8.8.8"]
}


# cidr cloud
locals {

  cidr_all = ["10.0.0.0/12", "10.104.16.0/21"] # US GOV

  cidr_region = {
    usgovva_compute   = [cidrsubnet(local.cidr_all[0], 3, 0)] # 10.0.0.0/15
    usgovva_transport = [cidrsubnet(local.cidr_all[1], 1, 0)] # 10.104.16.0/22
  }

  cidr_vnet = {
    usgovva = {
      vnet_vhub    = [cidrsubnet(local.cidr_region.usgovva_transport[0], 1, 0)] # 10.104.16.0/23
      vnet_vhub_t1 = [cidrsubnet(local.cidr_region.usgovva_transport[0], 2, 2)] # 10.104.18.0/24
      vnet_vhub_t2 = [cidrsubnet(local.cidr_region.usgovva_transport[0], 2, 3)] # 10.104.19.0/24 (reseved)
    }
  }

  vhub_t1_1 = [cidrsubnet(local.cidr_vnet.usgovva.vnet_vhub_t1[0], 1, 0)] # 10.104.18.0/25 (HQ)
  vhub_t1_2 = [cidrsubnet(local.cidr_vnet.usgovva.vnet_vhub_t1[0], 1, 1)] # 10.104.18.128/25 (EQ)

  cidr_subnet = {
    usgovva = {
      vnet_vhub = {
        subnet_vhub = local.cidr_vnet.usgovva.vnet_vhub[0]
        # 0 - 10.104.16.0/23 for vhub
        vhub_t1_1 = cidrsubnets(local.vhub_t1_1[0], 5, 5, 5, 5, 3, 2, 1)
        # 0 - /30 for private peering1
        # 1 - /30 reserved
        # 2 - /30 reserved
        # 3 - /30 reserved
        # 4 - /28 reserved
        # 5 - /27 reserved
        # 6 - /26 reserved
        vhub_t2_1 = cidrsubnets(local.vhub_t1_2[0], 5, 5, 5, 5, 3, 2, 1)
        # 0 - /30 for private peering1
        # 1 - /30 reserved
        # 2 - /30 reserved
        # 3 - /30 reserved
        # 4 - /28 reserved
        # 5 - /27 reserved
        # 6 - /26 reserved
      }
    }
  }


  # referenced by the local.common to be returned by module call
  cidr = {
    all    = local.cidr_all
    region = local.cidr_region
    vnet   = local.cidr_vnet
    subnet = local.cidr_subnet
    dns    = local.dns
    onprem = local.cidr_onprem
    vpn    = local.vpn
  }

}


# tags back on enviroment
locals {
  prod_tags = {
    ApplicationName     = "Network Infrastructure"
    BusinessOwner       = "Wallace"
    InfrastructureOwner = "Wallace"
    Environment         = "Production"
    TechnologyOwner     = "Wallace"
    ApplicationOwner    = "Wallace"
  }
  dev_tags = {
    ApplicationName     = "Network Infrastructure"
    BusinessOwner       = "Wallace"
    InfrastructureOwner = "Wallace"
    Environment         = "Development"
    TechnologyOwner     = "Wallace"
    ApplicationOwner    = "Wallace"
  }
  transit_tags = {
    ApplicationName     = "Network Infrastructure"
    BusinessOwner       = "Wallace"
    InfrastructureOwner = "Wallace"
    Environment         = "Development"
    TechnologyOwner     = "Wallace"
    ApplicationOwner    = "Wallace"
  }
}


# set the tags return based on the DEV value
# currently three defined - prod / dev / transit
locals {
  tags = var.env == "prod" ? local.prod_tags : (
    var.env == "dev" ? local.dev_tags : (
    var.env == "transit" ? local.transit_tags : null)
  )
}



# create RSG - real name is prepended with local.env above
module "rsg" {
  source = "../../modules/network/rsg"
  main   = var.main
  rsg = {
    rsg1 : {
      rsg_name     = local.rsg_name
      rsg_location = local.rsg_location
    }
  }
  env    = local.env
  common = local.tags
}


# common will be return to moudle call
locals {
  common = {
    env          = local.env
    rsg_name     = var.main ? module.rsg.rsg_name_name[local.rsg_name] : data.azurerm_resource_group.rsg.name
    rsg_location = var.main ? module.rsg.rsg_name_location[local.rsg_name] : data.azurerm_resource_group.rsg.location
    tags         = local.tags
    cidr         = local.cidr
    reg          = var.reg
  }
}

# return the common settings
output "common" {
  value = local.common
}


#
data "azurerm_resource_group" "rsg" {
  name = join("-", [local.env_rsg, local.rsg_name])
  depends_on = [
    module.rsg
  ]
}
