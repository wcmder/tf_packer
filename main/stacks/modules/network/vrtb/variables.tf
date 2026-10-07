
variable "vhub_id" {

}

variable "rtb" {
  type = map(object({
    #name    = string
    labels = list(string)
    route = map(object({
      name    = string
      dest    = list(string)
      nexthop = string
    }))
  }))
}

