data "aws_ssm_parameter" "this" {
  for_each = var.data_ssm_parameters

  name = each.value.name

  depends_on = [ aws_ssm_parameter.this ]

}


resource "aws_ssm_parameter" "this" {
  for_each = var.ssm_parameters

  name           = each.value.name
  description    = each.value.description
  type           = each.value.type
  value          = each.value.value
  tags           = each.value.tags

  lifecycle {
    ignore_changes = [value]
  }

}
