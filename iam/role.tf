resource "aws_iam_role" "this" {
  for_each           = var.iam_roles
  name               = each.value.name
  description        = each.value.description
  assume_role_policy = data.aws_iam_policy_document.this["${each.value.assume_role_policy_key}"].json
  tags               = each.value.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = { for i, policy in local.policy_attachments : "${policy.role_key}-${i}" => policy }

  role       = aws_iam_role.this[each.value.role_key].name
  policy_arn = each.value.policy_arn
}

resource "aws_iam_role_policy" "this" {
  for_each = { for i, policy in local.role_policicys : "${policy.role_key}-${i}" => policy }
  name     = each.value.role_policy_key
  role     = aws_iam_role.this[each.value.role_key].name
  policy   = data.aws_iam_policy_document.this[each.value.role_policy_key].json
}
