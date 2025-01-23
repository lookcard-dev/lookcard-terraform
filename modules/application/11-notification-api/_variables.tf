data "aws_secretsmanager_secret" "sentry" {
  name = "SENTRY"
}

data "aws_secretsmanager_secret" "postmark" {
  name = "POSTMARK"
}

data "aws_secretsmanager_secret" "twilio" {
  name = "TWILIO"
}

data "aws_secretsmanager_secret" "firebase" {
  name = "FIREBASE"
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
    vpc_id            = string
    private_subnet_ids = list(string)
    public_subnet_ids  = list(string)
    isolated_subnet_ids = list(string)
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
  ]
  environment_secrets = [
    {
      name      = "SENTRY_DSN"
      valueFrom = "${data.aws_secretsmanager_secret.sentry.arn}:${upper(replace(var.name, "-", "_"))}_DSN::"
    },
    {
      name      = "POSTMARK_API_KEY"
      valueFrom = "${data.aws_secretsmanager_secret.postmark.arn}:API_KEY::"
    },
    {
      name      = "TWILIO_ACCOUNT_SID"
      valueFrom = "${data.aws_secretsmanager_secret.twilio.arn}:ACCOUNT_SID::"
    },
    {
      name      = "TWILIO_AUTH_TOKEN"
      valueFrom = "${data.aws_secretsmanager_secret.twilio.arn}:AUTH_TOKEN::"
    },
    {
      name      = "TWILIO_MESSAGING_SERVICE_SID"
      valueFrom = "${data.aws_secretsmanager_secret.twilio.arn}:MESSAGING_SERVICE_SID::"
    },
    {
      name      = "FIREBASE_CREDENTIALS"
      valueFrom = "${data.aws_secretsmanager_secret.firebase.arn}:CREDENTIALS::"
    },
  ]
}

