
variable "rsg" {
  type = map(object({
    rsg_location = string
  }))

}

variable "common" {
  type = object({
    env          = string,
    reg          = string,
    rsg_name     = optional(string),
    rsg_location = optional(string),
    tags         = map(any)
  })
}
