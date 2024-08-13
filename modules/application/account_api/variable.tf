variable "default_listener" {}
variable "vpc_id" {}
# variable "api_lookcardlocal_namespace" {}
variable "lookcardlocal_namespace" {}
variable "cluster" {}
variable "secret_manager" {}
variable "sqs" {}
variable "acm" {}

variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}

variable "image" {
  type = object({
    url = string
    tag = string
  })
}

locals {
  application = {
    name      = "Account-API"
    port      = 8080
    image     = var.image.url
    image_tag = var.image.tag
  }
  load_balancer = {
    api_path = ["/accounts", "/account", "/account/*"]
  }
  ecs_task_secret_vars = [
    {
      name      = "DATABASE_URL"
      valueFrom = "${var.secret_manager.crypto_api_secret_arn}:DATABASE_URL::"
    },
    {
      name      = "FIREBASE_PROJECT_ID"
      valueFrom = "${var.secret_manager.firebase_secret_arn}:PROJECT_ID::"
    },
    {
      name      = "FIREBASE_SERVICE_ACCOUNT_PRIVATE_KEY"
      valueFrom = "${var.secret_manager.firebase_secret_arn}:SERVICE_ACCOUNT_PRIVATE_KEY::"
    },
    {
      name      = "FIREBASE_SERVICE_ACCOUNT_CLIENT_EMAIL"
      valueFrom = "${var.secret_manager.firebase_secret_arn}:SERVICE_ACCOUNT_CLIENT_EMAIL::"
    },
    {
      name      = "FIREBASE_CREDENTIALS"
      valueFrom = "${var.secret_manager.firebase_secret_arn}:CREDENTIALS::"
    },
    {
      name      = "API_KEY"
      valueFrom = "${var.secret_manager.elliptic_secret_arn}:API_KEY::"
    },
    {
      name      = "API_SECRET"
      valueFrom = "${var.secret_manager.elliptic_secret_arn}:API_SECRET::"
    },
    {
      name      = "DATABASE_ENDPOINT"
      valueFrom = "${var.secret_manager.database_secret_arn}:host::"
    },
    {
      name      = "DATABASE_USERNAME"
      valueFrom = "${var.secret_manager.database_secret_arn}:username::"
    },
    {
      name      = "DATABASE_PASSWORD"
      valueFrom = "${var.secret_manager.database_secret_arn}:password::"
    },
    {
      name      = "SENTRY_DSN"
      valueFrom = "${var.secret_manager.sentry_secret_arn}:ACCOUNT_API_DSN::"
    }
  ]
  ecs_task_env_vars = [
    {
      name  = "CRYPTO_API_URL"
      value = "https://${var.acm.domain_api_name}"
      # value = "https://api.develop.not-lookcard.com"
    },
    {
      name  = "DATABASE_NAME"
      value = "main"
    },
    {
      name  = "DATABASE_SCHEMA"
      value = "account"
    },
    {
      name  = "SQS_NOTIFICATION_QUEUE_URL"
      value = var.sqs.lookcard_notification_queue_url
    },
    {
      name  = "SQS_ACCOUNT_WITHDRAWAL_QUEUE_URL"
      value = var.sqs.crypto_fund_withdrawal_queue_url
    },
    {
      name  = "DATABASE_ARGS"
      value = "sslmode=require"
    },
    {
      name  = "AWS_XRAY_DAEMON_ENDPOINT"
      value = "xray.daemon.lookcard.local:2337"
    }
  ]
  iam_secrets = [
    var.secret_manager.crypto_api_secret_arn,
    var.secret_manager.firebase_secret_arn,
    var.secret_manager.database_secret_arn,
    var.secret_manager.sentry_secret_arn,
    var.secret_manager.elliptic_secret_arn
  ]
}

