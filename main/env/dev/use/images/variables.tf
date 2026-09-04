variable "spn-client-id" {
  type = string
}

variable "spn-client-secret" {
  type      = string
  sensitive = true
}

variable "spn-tenant-id" {
  type = string
}

variable "dev_subscription_id" {
  type    = string
  default = "a4b57fa5-2f2c-4732-b452-32be7d1724b1"
}
