# bastion nsg
module "default_nsg" {
  source = "../nsg"
  common = var.common
  nsg = {
    (var.nsg_name) : {
      security_rule = null
    }
  }
}


output "nsg_name_id" {
  value = module.default_nsg.nsg_name_id
}

output "nsg_name_name" {
  value = module.default_nsg.nsg_name_name
}
