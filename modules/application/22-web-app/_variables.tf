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

variable "name" {
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

variable "cluster_id" {
  type        = string
  description = "ECS cluster ID"
}

variable "namespace_id" {
  type        = string
  description = "Service discovery namespace ID"
}

variable "elb" {
  type = object({
    network_load_balancer_arn                   = string
    network_load_balancer_dns_name              = string
    application_load_balancer_arn               = string
    application_load_balancer_dns_name          = string
    application_load_balancer_http_listener_arn = string
    application_load_balancer_arn_suffix        = string
    network_load_balancer_arn_suffix            = string
  })
  description = "Load balancer configuration"
}

variable "allow_to_security_group_ids" {
  type = list(string)
}

variable "external_security_group_ids" {
  type = object({
    alb    = string
    bastion = optional(string)
  })
  description = "External security group IDs for access rules"
}

variable "image_tag" {
  type = string
}

variable "secret_arns" {
  type = map(string)
}

variable "repository_urls" {
  type = map(string)
}

variable "domain" {
  type = object({
    general = object({
      name    = string
      zone_id = string
    })
  })
}

variable "web_acl_id" {
  type        = string
  description = "Web Application Firewall ACL ID"
  default     = null
}
