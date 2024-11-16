resource "aws_ecs_task_definition" "this" {
  for_each = var.task_definitions

  track_latest             = each.value.track_latest
  family                   = each.value.family
  network_mode             = each.value.network_mode
  requires_compatibilities = each.value.requires_compatibilities
  cpu                      = each.value.cpu
  memory                   = each.value.memory
  execution_role_arn       = each.value.role_arn
  task_role_arn            = each.value.task_role_arn
  skip_destroy             = each.value.skip_destroy
  tags                     = each.value.tags
  container_definitions    = jsonencode(each.value.container_definitions)

  dynamic "volume" {
    for_each = each.value.volumes
    content {
      name = volume.value.name

      efs_volume_configuration {
        file_system_id     = volume.value.efs_volume_configuration.file_system_id
        transit_encryption = volume.value.efs_volume_configuration.transit_encryption
        
        authorization_config {
          access_point_id = volume.value.efs_volume_configuration.authorization_config.access_point_id
          iam = volume.value.efs_volume_configuration.authorization_config.iam
        }

      }
    }
  }
}
