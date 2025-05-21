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

variable "cluster_id" {
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

variable "secret_arns" {
  type = map(string)
}

variable "external_security_group_ids" {
  type = object({
    bastion_host = string
    ecs_cluster  = string
  })
}

variable "repository_urls" {
  type = map(string)
}

locals {
  environment_variables = [
    {
      name  = "RUNTIME_ENVIRONMENT"
      value = var.runtime_environment
    },
    {
      name  = "REDIS_HOST"
      value = "datacache.lookcard.local"
    },
    {
      name  = "AWS_XRAY_DAEMON_ENDPOINT"
      value = "xray.daemon.lookcard.local:2337"
    },
    {
      name  = "AWS_DYNAMODB_BLOCK_RECORDER_TABLE_NAME"
      value = aws_dynamodb_table.block_recorder.name
    },
    {
      name  = "AWS_DYNAMODB_GUARD_RECORDER_TABLE_NAME"
      value = aws_dynamodb_table.guard_recorder.name
    },
    {
      name  = "LOG_LEVEL"
      value = "info"
    }
  ]
  environment_secrets = []
}

