terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.us_east_1]
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }
}

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

variable "cluster_id" {
  type = string
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
  })
}

variable "secret_arns" {
  type        = map(string)
  description = "Map of secret ARNs for DATABASE, SUPABASE, SMTP, and SENTRY configurations"
}

variable "external_security_group_ids" {
  type = object({
    alb = string
  })
}

variable "elb" {
  type = object({
    network_load_balancer_arn     = string
    application_load_balancer_arn = string

    network_load_balancer_dns_name     = string
    application_load_balancer_dns_name = string

    application_load_balancer_http_listener_arn = string

    application_load_balancer_arn_suffix = string
    network_load_balancer_arn_suffix     = string
  })
}

variable "api_gateway" {
  type = object({
    vpc_link_arn = string
    vpc_link_id  = string
  })
}

data "aws_secretsmanager_secret_version" "supabase" {
  secret_id = var.secret_arns["SUPABASE"]
}

data "aws_secretsmanager_secret_version" "database" {
  secret_id = var.secret_arns["DATABASE"]
}
