output "logs_group_name" {
  value = {
    for k, v in aws_cloudwatch_log_group.this : k => v.name
  }
}
