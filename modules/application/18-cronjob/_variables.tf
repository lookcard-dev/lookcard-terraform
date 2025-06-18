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

variable "allow_to_security_group_ids" {
  type = list(string)
}

variable "external_security_group_ids" {
  type = object({
    account_api = string
    crypto_api  = string
  })
}

variable "image_tag" {
  type = string
}

variable "api_image_tags" {
  type = object({
    account_api = string
    crypto_api  = string
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

variable "cluster_id" {
  type = string
}

variable "secret_arns" {
  type = map(string)
}

variable "repository_urls" {
  type = map(string)
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
    # {
    #   name  = "DATABASE_SCHEMA"
    #   value = replace(var.name, "-", "_")
    # }
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
  ]
}
