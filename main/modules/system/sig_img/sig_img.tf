terraform {
  required_version = ">=1.0.2"
}


resource "azurerm_shared_image" "sig_img" {
  name                = var.img_name
  gallery_name        = var.sig_name
  resource_group_name = var.common["rsg_name"]
  location            = var.common["reg"]
  os_type             = var.os_type
  hyper_v_generation  = var.hyper_v_generation

  identifier {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
  }
}



output "img_id" {
  value = azurerm_shared_image.sig_img.id
}
