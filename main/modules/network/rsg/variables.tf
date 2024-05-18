
variable "rsg" {
  type = map(object({
    rsg_name = string
    rsg_location = string
  }))
  
}


variable "env" {

}

variable "main" {
  type = bool
}


variable "common" {
  type = map(any)
}
