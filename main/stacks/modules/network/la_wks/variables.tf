
variable "common" {
  type = object({
    env          = string,
    reg          = string,
    rsg_name     = string,
    rsg_location = string,
    tags         = map(any)
  })
}

variable "name" {

}

variable "sku" {
  default = "PerGB2018"
  # Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018 (new SKU as of 2018-04-03). Defaults to PerGB2018.
}

variable "retention_in_days" {
  type    = number
  default = 90
}


variable "daily_quota_gb" {
  type    = number
  default = -1
  # Defaults to -1 (unlimited) 

}
