
variable "runtime_environment"{
  type = string
  default = "develop"
}

variable "cluster_arn" {
  type = string
}

variable "namespace_id" {
  type = string
}

variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}

variable "database" {
  type = object({
    writer_endpoint = string
    reader_endpoint = string
    credentials_secret_arn = string
  })
}

variable "cache" {
  type = object({
    redis_endpoint = string
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

variable "image" {
  type = object({
    url = string
    tag = string
  })
}

variable "signer_keys_arn" {
  type = list(string)
  default = []
}



locals {
  application = {
    name      = "crypto-api"
    port      = 8080
    image     = var.image.url
    image_tag = var.image.tag
  }
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
      value = var.cache.redis_endpoint
    },
    {
      name  = "DATABASE_HOST"
      value = var.database.writer_endpoint
    },
    {
      name  = "DATABASE_READ_HOST"
      value = var.database.reader_endpoint
    },
    {
      name  = "DATABASE_PORT"
      value = "5432"
    },
    {
      name  = "DATABASE_SCHEMA"
      value = "crypto"
    }
  ]
  environment_secrets = [
    {
      name      = "DATABASE_NAME"
      valueFrom = "${var.database.credentials_secret_arn}:dbname::"
    },
    {
      name      = "DATABASE_USERNAME"
      valueFrom = "${var.database.credentials_secret_arn}:username::"
    },
    {
      name      = "DATABASE_PASSWORD"
      valueFrom = "${var.database.credentials_secret_arn}:password::"
    },
    {
      name      = "SENTRY_DSN"
      valueFrom = "${var.monitor.sentry_secret_arn}:CRYPTO_API_DSN::"
    },
  ]
}

