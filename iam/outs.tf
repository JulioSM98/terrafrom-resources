output "arn_role" {
  value = {
    for k, v in aws_iam_role.this : k => v.arn
  }
}
