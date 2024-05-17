
variable "common" {
  type = object({
    env          = string,
    reg          = string,
    rsg_name     = string,
    rsg_location = string,
    tags         = map(any)
  })
}


variable "ergw_conn" {
  type = map(object({
    ergw_conn_name = string
    ergw_id        = string
    erpeering_id   = string
    inet_security  = optional(bool, false)
    bypass         = optional(bool, false)
    routing_weight = optional(number, 0)

    routing = optional(map(object({
      assc_rt_id       = optional(string)
      in_route_map_id  = optional(string)
      out_route_map_id = optional(string)

      propagated_route_table = optional(map(object({
        label_name_list = optional(list(string))
        rt_id_list      = optional(list(string))
      })))

    })))
  }))
}
