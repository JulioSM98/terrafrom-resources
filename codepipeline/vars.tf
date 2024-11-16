variable "codepipelines" {
  type = map(object({
    name          = string
    pipeline_type = string
    role_arn      = string
    tags          = map(string)

    artifacts_stores = list(object({
      location = string
      type     = string
    }))

    triggers = list(object({
      provider_type = string
      git_configuration = object({
        source_action_name = string
        push = list(object({
          branches = object({
            includes = list(string)
          })
        }))
      })
    }))

    stages = list(object({
      name = string
      actions = list(object({
        name             = string
        owner            = string
        version          = string
        provider         = string
        category         = string
        region           = string
        run_order        = number
        input_artifacts  = list(string)
        output_artifacts = list(string)
        configuration    = map(string)
      }))
    }))

  }))
}
