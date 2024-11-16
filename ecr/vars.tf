variable "repositories" {
  type = map(object({
    repository_name      = string
    image_tag_mutability = string
    force_delete         = bool
    image_scanning_configuration = object({
      scan_on_push = bool
    })

    repository_lifecycle_policy = list(object({
      priority    = number
      description = string
      selection = object({
        tag_status   = string
        count_type   = string
        count_unit   = string
        count_number = number
      })
      action = object({
        type = string
      })
    }))

    tags = map(string)
  }))
}

