variable "albs" {
  type = map(object({
    name                             = string
    subnets                          = list(string)
    load_balancer_type               = string
    internal                         = bool
    enable_cross_zone_load_balancing = bool
    security_groups_keys             = list(string)
    idle_timeout                     = number
    tags                             = map(string)
  }))
}

variable "alb_listeners" {

  type = map(object({
    load_balancer_key = string
    port              = string
    protocol          = string
    certificate_arn   = string
    ssl_policy        = string
    default_action = object({
      type             = string
      target_group_key = string
      redirect = list(object({
        port        = string
        protocol    = string
        status_code = string
      }))

    })
    tags = map(string)
  }))

}

variable "lb_listener_rules" {
  type = map(object({
    listener_arn_key = string
    priority         = number
    actions = list(object({
      type                 = string
      target_group_arn_key = string
    }))

    conditions = list(object({

      path_pattern = object({
        values = list(string)
      })

      host_header = object({
        values = list(string)
      })

    }))

    tags = map(string)

  }))
}

variable "target_groups" {
  type = map(object({
    name             = string
    port             = number
    protocol         = string
    vpc_id           = string
    target_type      = string
    protocol_version = string
    tags             = map(string)
    health_check = object({
      path     = string
      port     = string
      protocol = string
    })
  }))
}

variable "security_groups" {
  type = map(object({
    name        = string
    description = string
    vpc_id      = string

    ingress = map(object({
      protocol    = string
      from_port   = number
      to_port     = number
      cidr_blocks = list(string)
    }))

    egress = map(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))

    tags = map(string)
  }))
}

variable "ingress_rules" {
  type = map(object({
    security_group_key            = string
    ip_protocol                   = string
    from_port                     = string
    to_port                       = string
    cidr_ipv4                     = string
    referenced_security_group_key = string
  }))
}

variable "egress_rules" {
  type = map(object({
    security_group_key            = string
    ip_protocol                   = string
    from_port                     = number
    to_port                       = number
    cidr_ipv4                     = string
    referenced_security_group_key = string
  }))
}
