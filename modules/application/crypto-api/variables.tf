
variable "lookcardlocal_namespace" {}
variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}

variable "default_listener" {}
variable "cluster" {}
variable "kms" {}
variable "secret_manager" {}

variable "image" {
  type = object({
    url = string
    tag = string
  })
}

locals {
  application = {
    name      = "crypto-api"
    port      = 8080
    image     = var.image.url
    image_tag = var.image.tag
  }
  load_balancer = {
    signer_api_path     = ["/signer", "/signers", "/signer/*"]
    blockchain_api_path = ["/blockchain", "/blockchain/*", "/blockchains"]
    hdwallet_path       = ["/hd-wallet"]
    signer_priority     = 10
    blockchain_priority = 101
    hdwallet_priority   = 100
  }
  ecs_task_secret_vars = [
    {
      name      = "DATABASE_URL"
      valueFrom = "${var.secret_manager.crypto_api_secret_arn}:DATABASE_URL::"
    },
    {
      name      = "FIREBASE_CREDENTIALS"
      valueFrom = "${var.secret_manager.firebase_secret_arn}:CREDENTIALS::"
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
      valueFrom = "${var.secret_manager.sentry_secret_arn}:CRYPTO_API_DSN::"
    },
  ]
  iam_secrets = [
    {
      arn = var.secret_manager.crypto_api_secret_arn
    },
    {
      arn = var.secret_manager.firebase_secret_arn
    },
    {
      arn = var.secret_manager.database_secret_arn
    }
  ]
}

