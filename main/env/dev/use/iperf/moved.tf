# Preserve the existing state while introducing the thin root and shared stack.
moved {
  from = module.main.module.rsg.azurerm_resource_group.rsg["rsg1"]
  to   = module.iperf.module.rsg.azurerm_resource_group.rsg["rg"]
}

moved {
  from = module.vnet
  to   = module.iperf.module.vnet
}

moved {
  from = module.subnet_lab
  to   = module.iperf.module.subnet_lab
}

moved {
  from = module.bastion_nsg
  to   = module.iperf.module.bastion_nsg
}

moved {
  from = module.iperf_nsg.azurerm_network_security_group.nsg["nsg1"]
  to   = module.iperf.module.iperf_nsg.azurerm_network_security_group.nsg["iperf_nsg"]
}

moved {
  from = module.nsg_assc
  to   = module.iperf.module.nsg_assc
}

moved {
  from = module.iperf_pip.azurerm_public_ip.pip
  to   = module.iperf.module.iperf_pip.azurerm_public_ip.pip["vm-vnet-iperf-pip"]
}

moved {
  from = module.iperf-vm
  to   = module.iperf.module.iperf-vm
}
