# Preserve the existing state while introducing the thin root and shared stack.
moved {
  from = module.main.module.rsg.azurerm_resource_group.rsg["rsg1"]
  to   = module.eve.module.rsg.azurerm_resource_group.rsg["rg"]
}

moved {
  from = module.vnet
  to   = module.eve.module.vnet
}

moved {
  from = module.subnet_lab
  to   = module.eve.module.subnet_lab
}

moved {
  from = module.bastion_nsg
  to   = module.eve.module.bastion_nsg
}

moved {
  from = module.eveng_nsg.azurerm_network_security_group.nsg["nsg1"]
  to   = module.eve.module.eveng_nsg.azurerm_network_security_group.nsg["eveng_nsg"]
}

moved {
  from = module.nsg_assc
  to   = module.eve.module.nsg_assc
}

moved {
  from = module.eveng1_pip.azurerm_public_ip.pip
  to   = module.eve.module.eveng1_pip.azurerm_public_ip.pip["vm-vnet-eveng1-pip"]
}

moved {
  from = module.eve-ng1-vm
  to   = module.eve.module.eve-ng1-vm
}

moved {
  from = module.sig
  to   = module.eve.module.sig
}

moved {
  from = module.sig_img_eveng1
  to   = module.eve.module.sig_img["0.1.0"]
}

moved {
  from = module.sig_img_eveng2
  to   = module.eve.module.sig_img["0.1.1"]
}

moved {
  from = module.sig_img_ver_010
  to   = module.eve.module.sig_img_ver["0.1.0"]
}

moved {
  from = module.sig_img_ver_011
  to   = module.eve.module.sig_img_ver["0.1.1"]
}
