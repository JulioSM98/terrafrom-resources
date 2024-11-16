variable "service_discovery_private_dns_namespaces" {
  type = map(object({
    name        = string
    vpc_id      = string
    description = string
    tags        = map(string)
  }))
}

variable "service_discovery_services" {
  type = map(object({
    name = string

    dns_configs = list(object({
      namespace_id_key = string
      dns_records = list(object({
        ttl  = number
        type = string
      }))
    }))
    health_check_custom_configs = list(object({
      failure_threshold = number
    }))
  }))
}
