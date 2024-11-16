output "efs_id" {
  value = {
    for k, v in aws_efs_file_system.this : k => v.id
  }
}

output "efs_access_points_id" {
  value = {
    for k, v in aws_efs_access_point.this : k => v.id
  }
}
