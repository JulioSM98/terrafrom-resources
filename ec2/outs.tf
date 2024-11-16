
output "alb_address" {
  value = {
    for k, v in aws_alb.this : k => v.dns_name
  }
}

output "alb_zone_id" {
  value = {
    for k, v in aws_alb.this : k => v.zone_id
  }
}

output "tg_arn" {
  value = {
    for k, v in aws_alb_target_group.this : k => v.arn
  }
}

output "sg_id" {
  value = {
    for k, v in aws_security_group.this : k => v.id
  }
}
