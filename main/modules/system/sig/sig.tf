terraform {
  required_version = ">=1.0.2"
}


resource "azurerm_shared_image_gallery" "sig" {
  name                = var.name
  resource_group_name = var.common["rsg_name"]
  location            = var.common["reg"]
  description         = "Shared images and things."

  tags = merge(var.common["tags"], { "ResourceType" = "Image Gallery" })
}



output "sig_unique_name" {
  value = azurerm_shared_image_gallery.sig.unique_name
}

output "sig_name" {
  value = var.name
}

output "sig_id" {
  value = azurerm_shared_image_gallery.sig.id
}
