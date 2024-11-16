resource "aws_servicecatalogappregistry_application" "this" {
  for_each = var.servicecatalogappregistry_applications

  name        = each.value.name
  description = each.value.description
  
}
