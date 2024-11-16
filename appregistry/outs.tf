output "application_tags" {
  value = {
    for k, v in aws_servicecatalogappregistry_application.this : k => v.application_tag
  }
}
