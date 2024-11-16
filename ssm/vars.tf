variable "data_ssm_parameters" {
  type = map(object({
    name = string
  }))
}

variable "ssm_parameters" {
  type = map(object({
    name        = string
    description = string
    type        = string
    value       = string
    tags        = map(string)
  }))
}
