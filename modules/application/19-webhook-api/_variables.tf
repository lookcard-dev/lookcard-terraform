terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.dns, aws.us_east_1]
    }
  }
}

data "aws_secretsmanager_secret" "sentry" {
  name = "SENTRY"
}

data "aws_secretsmanager_secret" "sumsub" {
  name = "SUMSUB"
}

data "aws_s3_bucket" "log_bucket" {
  bucket = "${var.aws_provider.account_id}-log"
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

variable "api_gateway" {
  type = object({
    vpc_link_arn = string
    vpc_link_id  = string
  })
}

variable "elb" {
  type = object({
    core_application_load_balancer_arn                    = string
    core_application_load_balancer_dns_name               = string
    core_application_load_balancer_http_listener_arn      = string
    composite_application_load_balancer_arn               = string
    composite_application_load_balancer_dns_name          = string
    composite_application_load_balancer_http_listener_arn = string
    composite_network_load_balancer_arn                   = string
    composite_network_load_balancer_dns_name              = string
    composite_network_load_balancer_http_listener_arn     = string
  })
}

variable "name" {
  type = string
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

variable "allow_to_security_group_ids" {
  type = list(string)
}

variable "image_tag" {
  type = string
}


variable "general_domain" {
  type = string
}

locals {
  environment_variables = [
    {
      name  = "PORT"
      value = "8080"
    },
    {
      name  = "CORS_ORIGINS"
      value = "*"
    },
    {
      name  = "RUNTIME_ENVIRONMENT"
      value = var.runtime_environment
    },
    {
      name  = "AWS_XRAY_DAEMON_ENDPOINT"
      value = "xray.daemon.lookcard.local:2337"
    },
    {
      name  = "AWS_CLOUDWATCH_LOG_GROUP_NAME"
      value = aws_cloudwatch_log_group.app_log_group.name
    },
    {
      name  = "AWS_FIREHOSE_SUMSUB_WEBHOOK_DELIVERY_STREAM_NAME"
      value = aws_kinesis_firehose_delivery_stream.sumsub_webhook.name
    },
    {
      name  = "AWS_FIREHOSE_REAP_WEBHOOK_DELIVERY_STREAM_NAME"
      value = aws_kinesis_firehose_delivery_stream.reap_webhook.name
    },
    {
      name  = "AWS_FIREHOSE_FIREBASE_WEBHOOK_DELIVERY_STREAM_NAME"
      value = aws_kinesis_firehose_delivery_stream.firebase_webhook.name
    }
  ]
  environment_secrets = [
    {
      name      = "SENTRY_DSN"
      valueFrom = "${data.aws_secretsmanager_secret.sentry.arn}:${upper(replace(var.name, "-", "_"))}_DSN::"
    },
    {
      name      = "SUMSUB_WEBHOOK_SECRET"
      valueFrom = "${data.aws_secretsmanager_secret.sumsub.arn}:WEBHOOK_SECRET::"
    }
  ]
}
