resource "aws_alb_target_group" "this" {
  for_each = var.target_groups

  name             = each.value.name
  port             = each.value.port
  protocol         = each.value.protocol
  vpc_id           = each.value.vpc_id
  target_type      = each.value.target_type
  protocol_version = each.value.protocol_version
  tags             = each.value.tags

  health_check {
    port     = each.value.health_check.port
    path     = each.value.health_check.path
    protocol = each.value.health_check.protocol
  }

}


