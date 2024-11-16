

output "task_definitions_container_name" {
  value = {
    for k, v in aws_ecs_task_definition.this : k => jsondecode(v.container_definitions)[0]["name"]
  }
}

output "ecs_service_name" {
  value = {
    for k, v in aws_ecs_service.this : k => v.name
  }
}

output "ecs_cluster_name" {
  value = {
    for k, v in aws_ecs_cluster.this : k => v.name
  }
}

output "ecs_cluster_id" {
  value = {
    for k, v in aws_ecs_cluster.this : k => v.id
  }
}