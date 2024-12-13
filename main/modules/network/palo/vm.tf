terraform {
  required_version = ">=1.0.2"
}


resource "azurerm_network_interface" "nic1" {
  name                = var.nic1_name
  location            = var.common["reg"]
  resource_group_name = var.common["rsg_name"]

  ip_configuration {
    name                          = var.ip1_name
    subnet_id                     = var.subnet1_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.pip1_id
  }

  tags = merge(var.common["tags"], { "ResourceType" = "Nic" })

}

resource "azurerm_network_interface" "nic2" {
  name                = var.nic2_name
  location            = var.common["reg"]
  resource_group_name = var.common["rsg_name"]

  ip_configuration {
    name                          = var.ip2_name
    subnet_id                     = var.subnet2_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.pip2_id
  }

  tags = merge(var.common["tags"], { "ResourceType" = "Nic" })

}


resource "azurerm_network_interface" "nic3" {
  name                = var.nic3_name
  location            = var.common["reg"]
  resource_group_name = var.common["rsg_name"]
  #enable_ip_forwarding = true

  ip_configuration {
    name                          = var.ip3_name
    subnet_id                     = var.subnet3_id
    private_ip_address_allocation = "Dynamic"
    #public_ip_address_id = var.pip3_id
  }

  tags = merge(var.common["tags"], { "ResourceType" = "Nic" })

}


resource "azurerm_virtual_machine" "vm" {
  name                             = var.vm_name
  resource_group_name              = var.common["rsg_name"]
  location                         = var.common["reg"]
  delete_data_disks_on_termination = true
  delete_os_disk_on_termination    = true
  vm_size                          = "Standard_DS3_v2"
  primary_network_interface_id     = azurerm_network_interface.nic2.id
  network_interface_ids = [
    azurerm_network_interface.nic1.id,
    azurerm_network_interface.nic2.id,
    azurerm_network_interface.nic3.id
  ]

  plan {
    publisher = "paloaltonetworks"
    product   = "vmseries-flex"
    name      = "bundle2"
  }

  storage_os_disk {
    name              = var.ssd_name
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  storage_image_reference {
    publisher = "paloaltonetworks"
    offer     = "vmseries-flex"
    sku       = "bundle2"
    version   = "latest"
  }

  os_profile {
    admin_username = "adminuser"
    admin_password = "12qwaszx!@QWASZX3"
    computer_name  = var.vm_name
  }

  tags = merge(var.common["tags"], { "ResourceType" = "Palo Alto" })

}


output "vm_name" {
  value = azurerm_virtual_machine.vm.name
}

