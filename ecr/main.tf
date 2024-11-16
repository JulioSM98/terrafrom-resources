resource "aws_ecr_repository" "this" {
  for_each = var.repositories

  name                 = each.value.repository_name
  image_tag_mutability = each.value.image_tag_mutability
  force_delete         = each.value.force_delete

  image_scanning_configuration {
    scan_on_push = each.value.image_scanning_configuration.scan_on_push
  }

  tags = each.value.tags
}

data "aws_ecr_lifecycle_policy_document" "this" {
  for_each = var.repositories

  dynamic "rule" {
    for_each = each.value.repository_lifecycle_policy
    content {
      priority    = rule.value.priority
      description = rule.value.description
      selection {
        tag_status   = rule.value.selection.tag_status
        count_type   = rule.value.selection.count_type
        count_unit   = rule.value.selection.count_unit
        count_number = rule.value.selection.count_number
      }
      action {
        type = rule.value.action.type
      }
    }
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  for_each   = var.repositories
  repository = aws_ecr_repository.this["${each.key}"].name
  policy     = data.aws_ecr_lifecycle_policy_document.this["${each.key}"].json
}
