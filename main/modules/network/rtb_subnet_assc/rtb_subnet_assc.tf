terraform {
  required_version = ">=1.0.2"
}


resource "azurerm_subnet_route_table_association" "rtba" {
  for_each                  = var.rtb_subnet
  route_table_id            = each.value.rtb_id
  subnet_id                 = each.value.subnet_id
}




