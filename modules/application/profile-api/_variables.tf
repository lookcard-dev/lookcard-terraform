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
    vpc            = string
    private_subnet_ids = list(string)
    public_subnet_ids  = list(string)
    isolated_subnet_ids = list(string)
  })
}

variable "datastore" {
  type = object({
    writer_endpoint = string
    reader_endpoint = string
    credentials_secret_arn = string
  })
}

variable "datacache" {
  type = object({
    endpoint = string
  })
}

variable "monitor" {
  type = object({
    sentry_secret_arn = string
  })
}

variable "allow_to_security_group_ids"{
  type = list(string)
}

variable "image_tag" {
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
      name = "AWS_DYNAMODB_PROFILE_DATA_TABLE_NAME",
      value = aws_dynamodb_table.profile_data.name
    }
  ]
  environment_secrets = [
    {
      name      = "DATABASE_NAME"
      valueFrom = "${var.datastore.credentials_secret_arn}:dbname::"
    },
    {
      name      = "DATABASE_USERNAME"
      valueFrom = "${var.datastore.credentials_secret_arn}:username::"
    },
    {
      name      = "DATABASE_PASSWORD"
      valueFrom = "${var.datastore.credentials_secret_arn}:password::"
    },
    {
      name      = "SENTRY_DSN"
      valueFrom = "${var.monitor.sentry_secret_arn}:CRYPTO_API_DSN::"
    },
  ]
}

