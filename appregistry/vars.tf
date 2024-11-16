variable "servicecatalogappregistry_applications" {
  type = map(object({
    name        = string
    description = string
  }))
}
