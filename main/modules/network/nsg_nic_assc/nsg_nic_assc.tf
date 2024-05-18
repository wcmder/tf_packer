# last udpate Oct2023

terraform {
  required_version = ">=1.6.2"
}


/* old with count
resource "azurerm_subnet_network_security_group_association" "nsga" {
  count                     = length(var.nsg_subnet)
  network_security_group_id = var.nsg_subnet[count.index][0]
  subnet_id                 = var.nsg_subnet[count.index][1]
}
}
*/


resource "azurerm_network_interface_security_group_association" "nsga" {
  for_each                  = var.nsg_nic
  network_security_group_id = each.value.nsg_id
  network_interface_id      = each.value.nic_id
}

