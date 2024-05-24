terraform {
  required_version = ">=1.0.2"
}


resource "azurerm_shared_image_version" "img_ver" {
  name                = var.ver
  gallery_name        = var.sig_name
  image_name          = var.img_name
  resource_group_name = var.common["rsg_name"]
  location            = var.common["reg"]

  target_region {
    name                   = var.common["reg"]
    regional_replica_count = 1
  }
}


output "img_ver_id" {
  value = azurerm_shared_image_version.img_ver.id
}
