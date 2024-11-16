variable "iam_policy_documents" {
  type = map(list(object({
    effect    = string
    actions   = list(string)
    resources = list(string)
    principals = list(object({
      type        = string
      identifiers = list(string)
    }))
  })))
}

variable "iam_roles" {
  type = map(object({
    name                   = string
    description            = string
    assume_role_policy_key = string
    role_policy_keys       = list(string)
    policy_attachments     = list(string)
    tags                   = map(string)
  }))
}

locals {

  policy_attachments = [for policy in flatten([
    for k, v in var.iam_roles : [
      for i, arn in zipmap(range(length(v.policy_attachments)), v.policy_attachments) : {
        role_key   = k
        policy_arn = arn
      }
    ] if v.policy_attachments != null
    ]) : policy
  ]

  role_policicys = [
    for policy in flatten([
      for k, v in var.iam_roles : [
        for i, doc in zipmap(range(length(v.role_policy_keys)), v.role_policy_keys) : {
          role_key        = k
          role_policy_key = doc
        }
      ] if v.role_policy_keys != null
    ]) : policy
  ]

}
