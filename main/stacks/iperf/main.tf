module "context" {
  source = "../context"

  env      = var.environment
  reg      = var.location
  svc_name = var.service_name
}

module "rsg" {
  source = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/network/rsg?ref=v0.1.6"

  common = module.context.common
  rsg = {
    (var.resource_group_name) = {
      rsg_location = var.location
    }
  }
}

locals {
  common = merge(module.context.common, {
    rsg_name     = module.rsg.rsg_name_name[var.resource_group_name]
    rsg_location = module.rsg.rsg_name_location[var.resource_group_name]
  })
}

module "vnet" {
  source = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/network/vnet?ref=v0.1.6"
  common = local.common
  vnet = {
    vm-vnet = {
      address_space_list = local.common.cidr.vnet.use.vnet_lab
      dns_server_list    = []
    }
  }
}

module "subnet_lab" {
  source    = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/network/subnet?ref=v0.1.6"
  common    = local.common
  vnet_name = module.vnet.vnet_name_name["vm-vnet"]
  subnet = {
    vm-subnet = {
      cidr_list = local.common.cidr.subnet.use.vnet_lab.subnet_lab_vm
    }
  }
}

module "iperf_nsg" {
  source = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/network/nsg?ref=v0.1.6"
  common = local.common
  nsg = {
    iperf_nsg = {
      security_rule = {
        allow_wder = {
          priority        = 100
          direction       = "Inbound"
          access          = "Allow"
          protocol        = "Tcp"
          src_port_range  = "*"
          dst_port_range  = "*"
          src_addr_prefix = "*"
          dst_addr_prefix = "*"
        }
      }
    }
  }
}

module "nsg_assc" {
  source = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/network/nsg_subnet_assc?ref=v0.1.6"
  nsg_subnet = {
    vm = {
      nsg_id    = module.iperf_nsg.nsg_name_id["iperf_nsg"]
      subnet_id = module.subnet_lab.subnet_name_id["vm-subnet"]
    }
  }
}

module "iperf_pip" {
  source = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/network/pip?ref=v0.1.6"
  common = local.common
  pip = {
    vm-vnet-iperf-pip = {}
  }
}

data "azurerm_shared_image_version" "iperf" {
  name                = var.iperf_image_version
  image_name          = "iperf"
  gallery_name        = "image_gallery"
  resource_group_name = var.image_resource_group_name
}

module "iperf-vm" {
  source                         = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/system/vm?ref=v0.1.11"
  admin_username                 = var.vm_admin_username
  admin_password                 = var.vm_admin_password
  common                         = local.common
  vm_name                        = "iperf-vm"
  nic_name                       = "iperf-nic"
  ip_name                        = "iperf-ip"
  subnet_id                      = module.subnet_lab.subnet_name_id["vm-subnet"]
  pip_addr_id                    = module.iperf_pip.pip_name_id["vm-vnet-iperf-pip"]
  vm_size                        = "Standard_D4s_v5"
  src_img_id                     = data.azurerm_shared_image_version.iperf.id
  accelerated_networking_enabled = true
}

# Resolve the ID using the VM name exposed by the pinned VM module.
data "azurerm_virtual_machine" "iperf" {
  name                = module.iperf-vm.vm_name
  resource_group_name = local.common.rsg_name

  depends_on = [module.iperf-vm]
}

resource "azurerm_virtual_machine_extension" "iperf" {
  name                       = "iperf-server"
  virtual_machine_id         = data.azurerm_virtual_machine.iperf.id
  publisher                  = "Microsoft.Azure.Extensions"
  type                       = "CustomScript"
  type_handler_version       = "2.1"
  auto_upgrade_minor_version = true

  protected_settings = jsonencode({
    script = filebase64("${path.module}/start-iperf.sh")
  })

  tags = local.common.tags
}
