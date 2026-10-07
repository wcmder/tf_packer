locals {
  vnc_id = var.fw_vnc_id
  hub    = split("/", local.vnc_id)[8]
  vnc    = split("/", local.vnc_id)[10]
}

#/subscriptions/51a8990c-6a51-41f0-88d7-b12a503fba18/resourceGroups/prod-use-cyberlabnetwork-vwan-rg01/providers/Microsoft.Network/virtualHubs/prod-use-cyberlabnetwork-hub/hubVirtualNetworkConnections/prod-use-cyberlabnetwork-afw-vnet-vnc"
locals {
  ids = {
    use_vnc_id = replace(replace(local.vnc_id, local.vnc, "prod-use-cyberlabnetwork-afw-vnet-vnc"), local.hub, "prod-use-cyberlabnetwork-hub")
  }
}

output "vnc_id" {
  value = local.ids
}
