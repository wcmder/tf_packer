resource "azurerm_network_interface" "nic" {
  name                           = join("-", [var.common["env"], var.nic_name])
  location                       = var.common["reg"]
  resource_group_name            = var.common["rsg_name"]
  ip_forwarding_enabled          = var.ip_forwarding_enabled
  accelerated_networking_enabled = var.accelerated_networking_enabled

  ip_configuration {
    name                          = join("-", [var.common["env"], var.ip_name])
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address == null ? "Dynamic" : "Static"
    private_ip_address            = var.private_ip_address
    public_ip_address_id          = var.pip_addr_id
  }

  tags = merge(var.common["tags"], { "ResourceType" = "Nic" })

}

resource "azurerm_linux_virtual_machine" "ubuntu" {
  name                            = join("-", [var.common["env"], var.vm_name])
  resource_group_name             = var.common["rsg_name"]
  location                        = var.common["reg"]
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = "false"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  /*admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }*/

  os_disk {
    disk_size_gb         = var.os_disk_size_gb
    caching              = var.caching
    storage_account_type = var.storage_account_type
  }


  dynamic "source_image_reference" {
    for_each = var.src_img_id == null ? [1] : []

    content {
      publisher = var.publisher
      offer     = var.offer
      sku       = var.sku
      version   = var.ver
    }
  }

  source_image_id = var.src_img_id

  tags = merge(var.common["tags"], { "ResourceType" = "Virtual Machine" })

}


output "vm_name" {
  value = azurerm_linux_virtual_machine.ubuntu.name
}

output "private_ip_address" {
  description = "Private IP address assigned to the VM network interface."
  value       = azurerm_network_interface.nic.private_ip_address
}

output "vm_id" {
  description = "Azure resource ID of the VM."
  value       = azurerm_linux_virtual_machine.ubuntu.id
}
