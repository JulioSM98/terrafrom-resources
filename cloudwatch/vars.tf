variable "logs_groups" {
  type = map(object({
    name              = string
    retention_in_days = number
    tags              = map(string)
  }))
}
