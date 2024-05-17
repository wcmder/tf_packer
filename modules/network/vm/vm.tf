terraform {
  required_version = ">=1.0.2"
}


resource "azurerm_network_interface" "nic" {
  name                = join("-", [var.common["env"], var.nic_name])
  location            = var.common["reg"]
  resource_group_name = var.common["rsg_name"]

  ip_configuration {
    name                          = join("-", [var.common["env"], var.ip_name])
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = merge(var.common["tags"], {"ResourceType" = "Nic"})

}

resource "azurerm_linux_virtual_machine" "ubuntu" {
  name                            = join("-", [var.common["env"], var.vm_name])
  resource_group_name             = var.common["rsg_name"]
  location                        = var.common["reg"]
  size                            = "Standard_F2"
  admin_username                  = "adminuser"
  admin_password                  = "12qwaszx!@QWASZX"
  disable_password_authentication = "false"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  /*admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }*/

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = merge(var.common["tags"], {"ResourceType" = "Virtual Machine"})
  
}


output "vm_name" {
  value = azurerm_linux_virtual_machine.ubuntu.name
}

