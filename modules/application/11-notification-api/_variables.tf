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
      valueFrom = "${var.secret_arns["SENTRY"]}:${upper(replace(var.name, "-", "_"))}_DSN::"
    },
    {
      name      = "POSTMARK_API_KEY"
      valueFrom = "${var.secret_arns["POSTMARK"]}:API_KEY::"
    },
    {
      name      = "TWILIO_ACCOUNT_SID"
      valueFrom = "${var.secret_arns["TWILIO"]}:ACCOUNT_SID::"
    },
    {
      name      = "TWILIO_AUTH_TOKEN"
      valueFrom = "${var.secret_arns["TWILIO"]}:AUTH_TOKEN::"
    },
    {
      name      = "TWILIO_MESSAGING_SERVICE_SID"
      valueFrom = "${var.secret_arns["TWILIO"]}:MESSAGING_SERVICE_SID::"
    },
    {
      name      = "FIREBASE_CREDENTIALS_BASE64"
      valueFrom = "${var.secret_arns["FIREBASE"]}:CREDENTIALS_BASE64::"
    },
    {
      name      = "TELEGRAM_BOT_TOKEN"
      valueFrom = "${var.secret_arns["TELEGRAM"]}:BOT_TOKEN::"
    },
    {
      name      = "TELEGRAM_NOTIFICATION_GROUP_CHAT_ID"
      valueFrom = "${var.secret_arns["TELEGRAM"]}:NOTIFICATION_GROUP_CHAT_ID::"
    },
    {
      name      = "TELEGRAM_NOTIFICATION_GENERAL_MESSAGE_THREAD_ID"
      valueFrom = "${var.secret_arns["TELEGRAM"]}:GENERAL_MESSAGE_THREAD_ID::"
    },
    {
      name      = "TELEGRAM_NOTIFICATION_TREASURY_EVENT_MESSAGE_THREAD_ID"
      valueFrom = "${var.secret_arns["TELEGRAM"]}:TREASURY_EVENT_MESSAGE_THREAD_ID::"
    },
    {
      name      = "TELEGRAM_NOTIFICATION_DEPOSIT_AND_WITHDRAWAL_MESSAGE_THREAD_ID"
      valueFrom = "${var.secret_arns["TELEGRAM"]}:DEPOSIT_AND_WITHDRAWAL_MESSAGE_THREAD_ID::"
    },
    {
      name      = "TELEGRAM_NOTIFICATION_CARD_TRANSACTION_MESSAGE_THREAD_ID"
      valueFrom = "${var.secret_arns["TELEGRAM"]}:CARD_TRANSACTION_MESSAGE_THREAD_ID::"
    }
  ]
}

