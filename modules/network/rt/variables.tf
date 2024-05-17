/*
terraform {
  # Optional attributes and the defaults function are
  # both experimental, so we must opt in to the experiment.
  experiments = [module_variable_optional_attrs]
}
*/


variable "common" {
  type = object ({
    env = string,
    reg = string,
    rsg_name = string,
    rsg_location = string,
    tags = map(any)
  })
}


variable "rtbs" {
  type = set(string)
}

variable "route" {
  type = map(any)
}