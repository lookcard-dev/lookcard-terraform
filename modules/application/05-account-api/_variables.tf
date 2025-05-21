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
  })
}

variable "repository_urls" {
  type = map(string)
}

locals {
  environment_variables = [
    {
      name  = "SERVICE_NAME",
      value = var.name
    },
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
      value = "datacache.lookcard.local"
    },
    {
      name  = "DATABASE_HOST"
      value = "rw.datastore.lookcard.local"
    },
    {
      name  = "DATABASE_READ_HOST"
      value = "ro.datastore.lookcard.local"
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
      name  = "PUPPETEER_CHROME_EXECUTABLE_PATH",
      value = "/usr/bin/google-chrome"
    },
    {
      name  = "PUPPETEER_ENABLE",
      value = "1"
    }
  ]
  environment_secrets = [
    {
      name      = "DATABASE_NAME"
      valueFrom = "${var.secret_arns["DATABASE"]}:dbname::"
    },
    {
      name      = "DATABASE_USERNAME"
      valueFrom = "${var.secret_arns["DATABASE"]}:username::"
    },
    {
      name      = "DATABASE_PASSWORD"
      valueFrom = "${var.secret_arns["DATABASE"]}:password::"
    },
    {
      name      = "SENTRY_DSN"
      valueFrom = "${var.secret_arns["SENTRY"]}:${upper(replace(var.name, "-", "_"))}_DSN::"
    },
  ]
}
