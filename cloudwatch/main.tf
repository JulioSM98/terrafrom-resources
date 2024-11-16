resource "aws_cloudwatch_log_group" "this" {
  for_each = var.logs_groups

  name              = each.value.name
  retention_in_days = each.value.retention_in_days
  tags              = each.value.tags
}
