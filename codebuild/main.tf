resource "aws_codebuild_project" "this" {
  for_each = var.codebuilds

  name          = each.value.name
  description   = each.value.description
  service_role  = each.value.service_role
  build_timeout = each.value.build_timeout
  tags          = each.value.tags
  artifacts {
    type                = each.value.artifacts.type
    encryption_disabled = each.value.artifacts.encryption_disabled

  }

  cache {
    type     = each.value.cache.type
    location = each.value.cache.location
    modes    = each.value.cache.modes
  }

  environment {
    compute_type                = each.value.environment.compute_type
    image                       = each.value.environment.image
    type                        = each.value.environment.type
    image_pull_credentials_type = each.value.environment.image_pull_credentials_type
    dynamic "environment_variable" {
      for_each = each.value.environment.environment_variables

      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = environment_variable.value.type
      }

    }
  }

  source {
    type      = each.value.source.type
    buildspec = base64decode(each.value.source.buildspec)
  }


  logs_config {
    cloudwatch_logs {
      group_name  = each.value.logs_config.cloudwatch_logs.group_name
      stream_name = each.value.logs_config.cloudwatch_logs.stream_name
      status      = each.value.logs_config.cloudwatch_logs.status
    }
  }
}
