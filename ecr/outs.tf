output "ecr_url" {
  value = {
    for k, v in aws_ecr_repository.this : k => v.repository_url
  }
}

output "ecr_arn" {
  value = {
    for k, v in aws_ecr_repository.this : k => v.arn
  }
}


output "ecr_name" {
  value = {
    for k, v in aws_ecr_repository.this : k => v.name
  }
}