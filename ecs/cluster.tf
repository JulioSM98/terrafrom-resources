resource "aws_ecs_cluster" "this" {
  for_each = var.clusters
  name     = each.value.name
  tags     = each.value.tags

  setting {
    name  = "containerInsights"
    value = each.value.containerInsights ? "enabled" : "disabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  for_each     = var.clusters
  cluster_name = aws_ecs_cluster.this["${each.key}"].name

  capacity_providers = each.value.capacity_providers.capacity_providers

  default_capacity_provider_strategy {
    base              = each.value.capacity_providers.capacity_provider_strategy.base
    weight            = each.value.capacity_providers.capacity_provider_strategy.weight
    capacity_provider = each.value.capacity_providers.capacity_provider_strategy.capacity_provider
  }
}




