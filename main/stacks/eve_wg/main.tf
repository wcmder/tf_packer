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

  wireguard_peer_blocks = join("\n\n", [
    for name, peer in var.wireguard_peers : <<-EOT
      # ${name}
      [Peer]
      PublicKey = ${peer.public_key}
      AllowedIPs = ${peer.address}
    EOT
  ])
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

module "eveng_nsg" {
  source = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/network/nsg?ref=v0.1.6"
  common = local.common
  nsg = {
    eveng_nsg = {
      security_rule = {
        allow_wireguard = {
          priority        = 100
          direction       = "Inbound"
          access          = "Allow"
          protocol        = "Udp"
          src_port_range  = "*"
          dst_port_range  = tostring(var.wireguard_port)
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
      nsg_id    = module.eveng_nsg.nsg_name_id["eveng_nsg"]
      subnet_id = module.subnet_lab.subnet_name_id["vm-subnet"]
    }
  }
}

module "eve_pip" {
  source = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/network/pip?ref=v0.1.6"
  common = local.common
  pip = {
    eve-wg-pip = {
      zones = ["1", "2", "3"]
    }
  }
}

data "azurerm_shared_image_version" "eveng_runtime" {
  name                = var.eve_image_version
  image_name          = "eve-ng"
  gallery_name        = "image_gallery"
  resource_group_name = var.image_resource_group_name
}

module "eve-ng1-vm" {
  source                = "git::https://dev.azure.com/wder/TF/_git/azure-terraform-modules//modules/system/vm?ref=v0.1.6"
  common                = local.common
  vm_name               = "eveng1-vm"
  nic_name              = "eveng1-nic"
  ip_name               = "eveng1-ip"
  subnet_id             = module.subnet_lab.subnet_name_id["vm-subnet"]
  pip_addr_id           = module.eve_pip.pip_name_id["eve-wg-pip"]
  ip_forwarding_enabled = true
  vm_size               = var.vm_size
  storage_account_type  = "StandardSSD_LRS"
  src_img_id            = data.azurerm_shared_image_version.eveng_runtime.id
}

data "azurerm_linux_virtual_machine" "eve" {
  name                = "${local.common.env}-eveng1-vm"
  resource_group_name = local.common.rsg_name

  depends_on = [module.eve-ng1-vm]
}

resource "azurerm_virtual_machine_extension" "wireguard" {
  name                       = "wireguard"
  virtual_machine_id         = data.azurerm_linux_virtual_machine.eve.id
  publisher                  = "Microsoft.Azure.Extensions"
  type                       = "CustomScript"
  type_handler_version       = "2.1"
  auto_upgrade_minor_version = true

  protected_settings = jsonencode({
    script = base64gzip(templatefile("${path.module}/wireguard.sh.tftpl", {
      listen_port    = var.wireguard_port
      server_address = var.wireguard_server_address
      client_cidr    = var.wireguard_client_cidr
      peer_blocks    = local.wireguard_peer_blocks
    }))
  })

  tags = local.common.tags
}

data "azurerm_public_ip" "eve" {
  name                = "${local.common.env}-eve-wg-pip"
  resource_group_name = local.common.rsg_name

  depends_on = [module.eve_pip]
}

output "eve_private_ip_address" {
  description = "Private address used to access EVE-NG from WireGuard."
  value       = data.azurerm_linux_virtual_machine.eve.private_ip_address
}

output "wireguard_public_ip_address" {
  description = "Public WireGuard endpoint address."
  value       = data.azurerm_public_ip.eve.ip_address
}

output "wireguard_port" {
  description = "UDP port used by the WireGuard endpoint."
  value       = var.wireguard_port
}
