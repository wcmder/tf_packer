

variable "rtb_subnet" {
  type = map(object({
    rtb_id = string
    subnet_id = string
  }))  
}

