data "aws_secretsmanager_secret" "database" {
  name = "DATABASE"
}

data "aws_secretsmanager_secret" "sentry" {
  name = "SENTRY"
}

data "aws_secretsmanager_secret" "tron_save" {
  name = "TRONSAVE"
}

data "aws_sqs_queue" "sweep_processor" {
  name = "Crypto_Processor-Sweep_Processor.fifo"
}

data "aws_sqs_queue" "withdrawal_processor" {
  name = "Crypto_Processor-Withdrawal_Processor.fifo"
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

variable "allow_to_security_group_ids" {
  type = list(string)
}

variable "image_tag" {
  type = string
}

variable "kms_key_arns" {
  type = object({
    crypto = object({
      worker = object({
        alpha = string
      })
      liquidity = string
    })
  })
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
      name  = "REDIS_HOST"
      value = var.datacache.endpoint
    },
    {
      name  = "DATABASE_HOST"
      value = var.datastore.writer_endpoint
    },
    {
      name  = "DATABASE_READ_HOST"
      value = var.datastore.reader_endpoint
    },
    {
      name  = "DATABASE_PORT"
      value = "5432"
    },
    {
      name  = "DATABASE_SCHEMA"
      value = replace(var.name, "-", "_")
    },
    {
      name  = "AWS_SQS_SWEEP_PROCESSOR_QUEUE_URL",
      value = data.aws_sqs_queue.sweep_processor.url
    },
    {
      name  = "AWS_SQS_WITHDRAWAL_PROCESSOR_QUEUE_URL",
      value = data.aws_sqs_queue.withdrawal_processor.url
    }
  ]
  environment_secrets = [
    {
      name      = "DATABASE_NAME"
      valueFrom = "${data.aws_secretsmanager_secret.database.arn}:dbname::"
    },
    {
      name      = "DATABASE_USERNAME"
      valueFrom = "${data.aws_secretsmanager_secret.database.arn}:username::"
    },
    {
      name      = "DATABASE_PASSWORD"
      valueFrom = "${data.aws_secretsmanager_secret.database.arn}:password::"
    },
    {
      name      = "SENTRY_DSN"
      valueFrom = "${data.aws_secretsmanager_secret.sentry.arn}:${upper(replace(var.name, "-", "_"))}_DSN::"
    },
    {
      name      = "TRONSAVE_BASE_URL"
      valueFrom = "${data.aws_secretsmanager_secret.tron_save.arn}:BASE_URL::"
    },
  ]
}

