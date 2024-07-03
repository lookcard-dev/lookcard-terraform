variable "lookcardlocal_namespace_id" {}
variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}

variable "default_listener" {}
variable "cluster" {}

variable "crypto_api_encryption_kms_arn" {}
variable "crypto_api_generator_kms_arn" {}
variable "secret_manager" {}

locals {
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
    }
  ]
  iam_secrets = [
    {
      arn   = var.secret_manager.crypto_api_secret_arn
    },
    {
      arn   = var.secret_manager.firebase_secret_arn
    },
    {
      arn   = var.secret_manager.database_secret_arn
    }
  ]
}

