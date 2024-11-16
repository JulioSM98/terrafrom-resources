resource "aws_ecs_service" "this" {
  for_each                           = var.services
  name                               = each.value.name
  cluster                            = each.value.cluster_key != null ? aws_ecs_cluster.this["${each.value.cluster_key}"].id : each.value.cluster_id
  task_definition                    = aws_ecs_task_definition.this["${each.value.task_definition_key}"].arn
  desired_count                      = each.value.desired_count
  deployment_maximum_percent         = each.value.deployment_maximum_percent
  deployment_minimum_healthy_percent = each.value.deployment_minimum_healthy_percent
  launch_type                        = each.value.launch_type
  enable_execute_command             = each.value.enable_execute_command
  health_check_grace_period_seconds  = each.value.health_check_grace_period_seconds
  tags                               = each.value.tags

  dynamic "service_registries" {
    for_each = each.value.service_registries != null ? [each.value.service_registries] : []
    content {
      registry_arn = service_registries.value.registry_arn
    }
  }

  network_configuration {
    security_groups  = each.value.network_configuration.security_groups
    subnets          = each.value.network_configuration.subnets
    assign_public_ip = each.value.network_configuration.assign_public_ip
  }

  dynamic "load_balancer" {
    for_each = each.value.load_balancers
    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = aws_ecs_task_definition.this["${each.value.task_definition_key}"].family
      container_port   = load_balancer.value.container_port
    }
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

}

resource "aws_appautoscaling_target" "this" {
  for_each = { for k, v in var.services : k => v if v.appautoscaling_target != null }

  max_capacity       = each.value.appautoscaling_target.max_capacity
  min_capacity       = each.value.appautoscaling_target.min_capacity
  resource_id        = each.value.cluster_key != null ? "service/${aws_ecs_cluster.this["${each.value.cluster_key}"].name}/${aws_ecs_service.this["${each.key}"].name}" : "service/${each.value.cluster_name}/${aws_ecs_service.this["${each.key}"].name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  tags               = each.value.tags
}

resource "aws_appautoscaling_policy" "this" {
  for_each = local.appautoscaling_policy_map

  name               = each.value.name
  policy_type        = each.value.policy_type
  resource_id        = aws_appautoscaling_target.this["${each.value.service_name}"].resource_id
  scalable_dimension = aws_appautoscaling_target.this["${each.value.service_name}"].scalable_dimension
  service_namespace  = aws_appautoscaling_target.this["${each.value.service_name}"].service_namespace

  dynamic "target_tracking_scaling_policy_configuration" {
    for_each = each.value.target_tracking_scaling_policy_configuration

    content {
      scale_in_cooldown  = target_tracking_scaling_policy_configuration.value.scale_in_cooldown
      scale_out_cooldown = target_tracking_scaling_policy_configuration.value.scale_out_cooldown
      target_value       = target_tracking_scaling_policy_configuration.value.target_value

      dynamic "predefined_metric_specification" {
        for_each = target_tracking_scaling_policy_configuration.value.predefined_metric_specification

        content {
          predefined_metric_type = predefined_metric_specification.value.predefined_metric_type
        }

      }

    }

  }

}
