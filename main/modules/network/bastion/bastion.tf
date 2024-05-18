terraform {
  required_version = ">=1.0.2"
}


resource "azurerm_bastion_host" "bastion" {
  name                = join("-", [var.common["env"], var.bastion_name])
  resource_group_name = var.common["rsg_name"]
  location            = var.common["reg"]
  sku                 = var.sku
  file_copy_enabled = var.file_copy_enabled
  ip_connect_enabled = var.ip_connect_enabled
  scale_units = var.scale_units 
  tunneling_enabled = var.tunneling_enabled 
  shareable_link_enabled = var.shareable_link_enabled 


  ip_configuration {
    name                 = join("-", [var.common["env"], var.bastion_name, var.ip_name])
    subnet_id            = var.subnet_id
    public_ip_address_id = var.pip_id
  }

  tags = merge(var.common["tags"], { "ResourceType" = "Bastion" })

}
