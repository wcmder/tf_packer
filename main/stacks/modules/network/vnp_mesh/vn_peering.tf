locals {
  vnet_name_id_map = var.vnet_name_id_map # to this vnets by ID, the name is for condition only
  vnet_name_list   = var.vnet_name_list   # from this vnets by name

  # this will create a full mesh list of each source vnet name to all destination vent id
  vnet_mesh_list = distinct(flatten([
    for name in local.vnet_name_list : [
      for n, id in local.vnet_name_id_map : {
        name = join("-to-", [name, element(split("/", id), length(split("/", id)) - 1)])
        id   = id
      } if name != n
    ]
  ]))

  # covert the list to map
  vnet_mesh = { for x in local.vnet_mesh_list : x.name => x.id }
}

resource "azurerm_virtual_network_peering" "mesh" {
  for_each                     = local.vnet_mesh
  resource_group_name          = var.common["rsg_name"]
  name                         = each.key
  virtual_network_name         = split("-to-", each.key)[0]
  remote_virtual_network_id    = each.value
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  allow_gateway_transit        = var.allow_gateway_transit
  use_remote_gateways          = var.use_remote_gateways

}


