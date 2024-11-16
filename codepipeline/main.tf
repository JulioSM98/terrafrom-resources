resource "aws_codepipeline" "this" {
  for_each      = var.codepipelines
  name          = each.value.name
  pipeline_type = each.value.pipeline_type
  role_arn      = each.value.role_arn
  tags          = each.value.tags

  dynamic "artifact_store" {
    for_each = each.value.artifacts_stores
    content {
      location = artifact_store.value.location
      type     = artifact_store.value.type
    }
  }

  dynamic "trigger" {
    for_each = each.value.triggers
    content {
      provider_type = trigger.value.provider_type
      git_configuration {
        source_action_name = trigger.value.git_configuration.source_action_name
        dynamic "push" {
          for_each = trigger.value.git_configuration.push
          content {
            branches {
              includes = push.value.branches.includes
            }
          }
        }
      }
    }
  }

  dynamic "stage" {
    for_each = each.value.stages
    content {
      name = stage.value.name
      dynamic "action" {
        for_each = stage.value.actions
        content {
          name             = action.value.name
          owner            = action.value.owner
          version          = action.value.version
          provider         = action.value.provider
          category         = action.value.category
          region           = action.value.region
          run_order        = action.value.run_order
          input_artifacts  = action.value.input_artifacts
          output_artifacts = action.value.output_artifacts
          configuration    = action.value.configuration
        }
      }
    }
  }

}
