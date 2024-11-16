resource "aws_alb" "this" {
  for_each = var.albs

  name                             = each.value.name
  subnets                          = each.value.subnets
  load_balancer_type               = each.value.load_balancer_type
  internal                         = each.value.internal
  enable_cross_zone_load_balancing = each.value.enable_cross_zone_load_balancing
  security_groups                  = try([for key in each.value.security_groups_keys : aws_security_group.this["${key}"].id], null)
  idle_timeout                     = each.value.idle_timeout
  tags                             = each.value.tags
}

resource "aws_alb_listener" "this" {
  for_each = var.alb_listeners

  load_balancer_arn = aws_alb.this["${each.value.load_balancer_key}"].id
  port              = each.value.port
  protocol          = each.value.protocol
  certificate_arn   = each.value.certificate_arn
  ssl_policy        = each.value.ssl_policy
  tags              = each.value.tags
  default_action {
    type             = each.value.default_action.type
    target_group_arn = try(aws_alb_target_group.this["${each.value.default_action.target_group_key}"].arn, null)

    dynamic "redirect" {
      for_each = each.value.default_action.redirect

      content {
        port        = redirect.value.port
        protocol    = redirect.value.protocol
        status_code = redirect.value.status_code
      }
    }

  }

}

resource "aws_lb_listener_rule" "this" {
  for_each = var.lb_listener_rules

  listener_arn = aws_alb_listener.this["${each.value.listener_arn_key}"].arn
  priority     = each.value.priority

  dynamic "action" {
    for_each = each.value.actions

    content {
      type             = action.value.type
      target_group_arn = aws_alb_target_group.this["${action.value.target_group_arn_key}"].arn
    }
  }

  dynamic "condition" {
    for_each = each.value.conditions
    content {

      dynamic "path_pattern" {
        for_each = condition.value.path_pattern != null ? [condition.value.path_pattern] : []
        content {
          values = path_pattern.value.values
        }
      }

      dynamic "host_header" {
        for_each = condition.value.host_header != null ? [condition.value.host_header] : []
        content {
          values = host_header.value.values
        }
      }

    }
  }

  tags = each.value.tags

}
