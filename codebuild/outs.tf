output "name" {
  value = {
    for k, v in aws_codebuild_project.this : k => v.name
  }
}
