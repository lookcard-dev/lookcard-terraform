variable "api_lookcardlocal_namespace" {}
variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}

variable "default_listener" {}
variable "dynamodb_config_api_config_data_name" {}
variable "dynamodb_config_api_config_data_arn" {}
variable "lookcard_api_domain" {}
variable "cluster" {}
# variable "secret_manager" {}

variable "image" {
  type = object({
    url = string
    tag = string
  })
}

locals {
  application = {
    name      = "config-api"
    port      = 8080
    image     = var.image.url
    image_tag = var.image.tag
  }
  load_balancer = {
    config_api_path = ["/configs", "/configs/*"]
    config_priority = 301
  }
  # ecs_task_secret_vars = [
  #   {
  #     name      = "DATABASE_URL"
  #     valueFrom = "${var.secret_manager.crypto_api_secret_arn}:DATABASE_URL::"
  #   },
  #   {
  #     name      = "FIREBASE_CREDENTIALS"
  #     valueFrom = "${var.secret_manager.firebase_secret_arn}:CREDENTIALS::"
  #   },
  #   {
  #     name      = "DATABASE_ENDPOINT"
  #     valueFrom = "${var.secret_manager.database_secret_arn}:host::"
  #   },
  #   {
  #     name      = "DATABASE_USERNAME"
  #     valueFrom = "${var.secret_manager.database_secret_arn}:username::"
  #   },
  #   {
  #     name      = "DATABASE_PASSWORD"
  #     valueFrom = "${var.secret_manager.database_secret_arn}:password::"
  #   }
  # ]
  # iam_secrets = [
  #   {
  #     arn = var.secret_manager.crypto_api_secret_arn
  #   },
  #   {
  #     arn = var.secret_manager.firebase_secret_arn
  #   },
  #   {
  #     arn = var.secret_manager.database_secret_arn
  #   }
  # ]
}

