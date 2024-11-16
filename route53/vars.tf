variable "records" {
  type = map(object({
    zone_id = string
    name    = string
    type    = string

    alias = object({
      name    = string
      zone_id = string
      health  = bool
    })

  }))
}
