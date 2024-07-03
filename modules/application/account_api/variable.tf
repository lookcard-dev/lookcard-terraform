variable "default_listener" {}
variable "vpc_id" {}
variable "lookcard_notification_sqs_url" {}
variable "crypto_fund_withdrawal_sqs_url" {}
variable "lookcardlocal_namespace_id" {}
variable "cluster" {}
variable "secret_manager" {}

variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}

variable "secret_arns" {
  description = "List of ARN for Secrets Manager"
  type        = list(string)
}

locals {
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
        }
      ]
    iam_secrets = [
        {
            sid   = "CryptoApiSecret"
            arn   = var.secret_manager.crypto_api_secret_arn
        },
        {
            sid   = "FirebaseSecret"
            arn   = var.secret_manager.firebase_secret_arn
        },
        {
            sid   = "DatabaseSecret"
            arn   = var.secret_manager.database_secret_arn
        },
        {
            sid   = "EllipticSecret"
            arn   = var.secret_manager.elliptic_secret_arn
        }
  ]
}

