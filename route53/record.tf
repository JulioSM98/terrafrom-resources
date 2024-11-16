resource "aws_route53_record" "record" {
  for_each = var.records
  zone_id  = each.value.zone_id
  name     = each.value.name
  type     = each.value.type

  alias {
    name                   = each.value.alias.name
    zone_id                = each.value.alias.zone_id
    evaluate_target_health = each.value.alias.health
  }

}
