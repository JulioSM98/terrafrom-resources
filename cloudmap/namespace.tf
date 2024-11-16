resource "aws_service_discovery_private_dns_namespace" "this" {
  for_each = var.service_discovery_private_dns_namespaces

  name        = each.value.name
  vpc         = each.value.vpc_id
  description = each.value.description
  tags        = each.value.tags
}

resource "aws_service_discovery_service" "this" {
  for_each = var.service_discovery_services
  name     = each.value.name

  dynamic "dns_config" {
    for_each = each.value.dns_configs
    content {
      namespace_id = aws_service_discovery_private_dns_namespace.this["${dns_config.value.namespace_id_key}"].id

      dynamic "dns_records" {

        for_each = dns_config.value.dns_records
        content {
          ttl  = dns_records.value.ttl
          type = dns_records.value.type
        }
      }
    }
  }

  dynamic "health_check_custom_config" {
    for_each = each.value.health_check_custom_configs
    content {
      failure_threshold = health_check_custom_config.value.failure_threshold
    }
  }


}
