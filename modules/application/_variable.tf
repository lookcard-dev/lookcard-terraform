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

variable "datastore" {
  type = object({
    writer_endpoint = string
    reader_endpoint = string
  })
}

variable "datacache" {
  type = object({
    endpoint = string
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

variable "elb" {
  type = object({
    application_load_balancer_arn = string
    application_load_balancer_dns_name = string
    network_load_balancer_arn     = string
    network_load_balancer_dns_name = string
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
    general = string
    admin   = string
  })
  default = {
    general = "develop.not-lookcard.com"
    admin   = "develop.not-lookcard.com"
  }
}
