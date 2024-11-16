data "aws_iam_policy_document" "this" {
  for_each = var.iam_policy_documents
  dynamic "statement" {
    for_each = each.value
    content {
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources
      dynamic "principals" {
        for_each = statement.value.principals
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }
    }
  }
}


