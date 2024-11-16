variable "codebuilds" {
  type = map(object({
    name          = string
    description   = string
    service_role  = string
    build_timeout = number
    tags          = map(string)
    artifacts = object({
      type                = string
      encryption_disabled = bool
    })

    cache = object({
      type     = string
      location = string
      modes    = list(string)
    })

    environment = object({
      compute_type                = string
      image                       = string
      type                        = string
      image_pull_credentials_type = string

      environment_variables = list(object({
        name  = string
        value = string
        type  = string
      }))

    })

    source = object({
      type = string
      buildspec = string
    })

    logs_config = object({
      cloudwatch_logs = object({
        group_name  = string
        stream_name = string
        status      = string
      })
    })

  }))
}
