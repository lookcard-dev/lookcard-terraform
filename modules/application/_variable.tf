variable "aws_provider" {
  type = object({
    region     = string
    account_id = string
  })
}

variable "runtime_environment" {
  type = string
  validation {
    condition     = contains(["develop", "testing", "staging", "production", "sandbox"], var.runtime_environment)
    error_message = "runtime_environment must be one of: develop, testing, staging, production, or sandbox"
  }
}

variable "cluster_ids" {
  type = object({
    listener              = string
    composite_application = string
    core_application      = string
    administrative        = string
    cronjob               = string
  })
}

variable "namespace_id" {
  type = string
}

variable "network" {
  type = object({
    vpc_id              = string
    private_subnet_ids  = list(string)
    public_subnet_ids   = list(string)
    isolated_subnet_ids = list(string)
  })
}


variable "components" {
  type = map(object({
    name = string
    hostname = object({
      internal = string
      public   = optional(string)
    })
    image_tag = string
  }))
}

variable "kms_key_arns" {
  type = object({
    data = object({
      generator  = string
      encryption = string
    })
    crypto = object({
      worker = object({
        alpha = string
      })
      liquidity = string
    })
  })
}

variable "s3_bucket" {
  type = object({
    arns = object({
      data = string
      log  = string
    })
    names = object({
      data = string
      log  = string
    })
  })
}

variable "elb" {
  type = object({
    application_load_balancer_arn               = string
    application_load_balancer_dns_name          = string
    network_load_balancer_arn                   = string
    network_load_balancer_dns_name              = string
    application_load_balancer_http_listener_arn = string
  })
}

variable "api_gateway" {
  type = object({
    vpc_link_arn = string
    vpc_link_id  = string
  })
}

variable "domain" {
  type = object({
    general = object({
      name    = string
      zone_id = string
    })
    admin = object({
      name    = string
      zone_id = string
    })
    developer = object({
      name    = string
      zone_id = string
    })
  })
}

variable "external_security_group_ids" {
  type = object({
    datastore = object({
      cluster = string
      proxy   = string
    })
    datacache    = string
    bastion_host = string
    ecs_cluster  = string
    alb          = string
  })
}

variable "secret_arns" {
  type = map(string)
}

variable "repository_urls" {
  type = map(string)
}

locals {
  datastore_access_security_group_ids = [
    module.user-api.security_group_id,
    module.account-api.security_group_id,
    module.crypto-api.security_group_id,
    module.referral-api.security_group_id,
    module.verification-api.security_group_id,
    module.reseller-api.security_group_id,
    module.approval-api.security_group_id,
    module.cronjob.security_group_id,
    module.card-api.security_group_id,
  ]

  datacache_access_security_group_ids = compact([
    module.user-api.security_group_id,
    module.account-api.security_group_id,
    module.crypto-api.security_group_id,
    module.referral-api.security_group_id,
    module.verification-api.security_group_id,
    module.reseller-api.security_group_id,
    module.approval-api.security_group_id,
    try(module.crypto-faucet[0].security_group_id, null),
    var.external_security_group_ids.ecs_cluster,
    module.card-api.security_group_id,
  ])
}
