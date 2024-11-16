variable "efs_file_systems" {
  type = map(object({

    lifecycle_policy = object({
      transition_to_ia = string
    })

    encrypted = bool
    tags      = map(string)

  }))
}

variable "efs_access_points" {
  type = map(object({
    file_system_key = string

    posix_user = object({
      uid = number
      gid = number
    })

    root_directory = object({
      path = string

      creation_info = object({
        owner_uid   = number
        owner_gid   = number
        permissions = string
      })

    })

    tags = map(string)

  }))
}

variable "efs_mount_targets" {
  type = map(object({
    file_system_key = string
    subnet_id       = string
  }))
}
