terraform {
  required_version = ">=1.0.2"
}


resource "azurerm_shared_image_gallery" "img_gallery" {
  name                = join("-", [var.common["env"], var.name])
  resource_group_name = var.common["rsg_name"]
  location            = var.common["reg"]
  description         = "Shared images and things."

  tags = merge(var.common["tags"], { "ResourceType" = "Image Gallery" })
}



output "img_gallery_name" {
  value = azurerm_shared_image_gallery.img_gallery.unique_name
}


output "img_gallery_id" {
  value = azurerm_shared_image_gallery.img_gallery.id
}
