
variable "route_table_id" {

}

variable "route" {
  type = map(object({
    dest_type = string
    dst_list  = list(string)
    hop_type  = string
    next_hop  = string
  }))
}