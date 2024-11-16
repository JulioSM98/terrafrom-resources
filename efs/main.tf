resource "aws_efs_file_system" "this" {
  for_each = var.efs_file_systems

  lifecycle_policy {
    transition_to_ia = each.value.lifecycle_policy.transition_to_ia
  }

  encrypted = each.value.encrypted

  tags = each.value.tags

}

resource "aws_efs_access_point" "this" {
  for_each       = var.efs_access_points
  file_system_id = aws_efs_file_system.this["${each.value.file_system_key}"].id

  posix_user {
    uid = each.value.posix_user.uid
    gid = each.value.posix_user.gid
  }

  root_directory {
    path = each.value.root_directory.path
    creation_info {
      owner_uid   = each.value.root_directory.creation_info.owner_uid
      owner_gid   = each.value.root_directory.creation_info.owner_gid
      permissions = each.value.root_directory.creation_info.permissions
    }
  }

  tags = each.value.tags

}

resource "aws_efs_mount_target" "this" {
  for_each = var.efs_mount_targets

  file_system_id = aws_efs_file_system.this["${each.value.file_system_key}"].id

  subnet_id = each.value.subnet_id


}
