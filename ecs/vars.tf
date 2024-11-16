variable "clusters" {
  type = map(object({
    name              = string
    containerInsights = bool

    capacity_providers = object({
      capacity_providers = list(string)
      capacity_provider_strategy = object({
        base              = number
        weight            = number
        capacity_provider = string
      })
    })
    tags = map(string)
  }))
}

variable "task_definitions" {
  type = map(object({
    track_latest             = bool
    family                   = string
    network_mode             = string
    requires_compatibilities = list(string)
    cpu                      = number
    memory                   = number
    role_arn                 = string
    task_role_arn            = string
    skip_destroy             = bool
    tags                     = map(string)

    container_definitions = list(object({
      name      = string
      image     = string
      cpu       = number
      memory    = number
      essential = bool
      ulimits = list(object({
        name      = string
        softLimit = number
        hardLimit = number
      }))
      network_mode = string

      logConfiguration = object({
        logDriver = string
        options = object({
          awslogs-create-group  = string
          awslogs-group         = string
          awslogs-region        = string
          awslogs-stream-prefix = string
        })
      })

      healthCheck = object({
        command  = list(string)
        interval = number
        timeout  = number
        retries  = number
      })

      command = list(string)

      mountPoints = list(object({
        sourceVolume  = string
        containerPath = string
      }))

      environment = list(object({
        name  = string
        value = string
      }))

      secrets = list(object({
        name      = string
        valueFrom = string
      }))

      portMappings = list(object({
        protocol      = string
        containerPort = number
        hostPort      = number
      }))

    }))

    volumes = list(object({
      name = string

      efs_volume_configuration = object({
        file_system_id     = string
        transit_encryption = string

        authorization_config = object({
          access_point_id = string
          iam             = string
        })

      })

    }))

  }))
}

variable "services" {
  type = map(object({

    name                               = string
    desired_count                      = number
    launch_type                        = string
    enable_execute_command             = bool
    health_check_grace_period_seconds  = number
    deployment_maximum_percent         = number
    deployment_minimum_healthy_percent = number

    cluster_key  = string
    cluster_id   = string
    cluster_name = string

    task_definition_key = string

    service_registries = object({
      registry_arn = string
    })

    network_configuration = object({
      security_groups  = list(string)
      subnets          = list(string)
      assign_public_ip = bool
    })

    load_balancers = list(object({
      target_group_arn = string
      container_port   = number
    }))

    appautoscaling_target = object({
      max_capacity = number
      min_capacity = number
    })

    appautoscaling_policy = map(object({
      name        = string
      policy_type = string

      target_tracking_scaling_policy_configuration = list(object({
        scale_in_cooldown  = number
        scale_out_cooldown = number
        target_value       = number

        predefined_metric_specification = list(object({
          predefined_metric_type = string
        }))

      }))

    }))

    tags = map(string)

  }))
}

locals {
  appautoscaling_policy_map = {
    for policy in flatten([
      for service, policies in var.services : [
        for policy_type, policy in policies.appautoscaling_policy : {
          key                                          = policy_type
          name                                         = policy.name
          policy_type                                  = policy.policy_type
          target_tracking_scaling_policy_configuration = policy.target_tracking_scaling_policy_configuration
          service_name                                 = service
        }
      ] if policies.appautoscaling_policy != null
    ]) : "${policy.service_name}-${policy.key}" => policy
  }
}
