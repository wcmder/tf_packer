terraform {
  required_version = ">=1.0.2"
}

/* old with count
resource "azurerm_subnet_network_security_group_association" "nsga" {
  count                     = length(var.nsg_subnet)
  network_security_group_id = var.nsg_subnet[count.index][0]
  subnet_id                 = var.nsg_subnet[count.index][1]
}
}
*/


resource "azurerm_subnet_network_security_group_association" "nsga" {
  for_each                  = var.nsg_subnet
  network_security_group_id = each.value.nsg_id
  subnet_id                 = each.value.subnet_id
}
