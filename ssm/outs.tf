output "values" {
  value = {
    for k, v in data.aws_ssm_parameter.this : k => v.value
  }
  sensitive = true
}
