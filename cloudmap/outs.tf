output "discovery_service_arn" {
  value = {
    for k, v in aws_service_discovery_service.this : k => v.arn
  }
}
