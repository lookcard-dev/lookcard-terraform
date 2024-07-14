variable "network" {
  description = "Network configuration"
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}
variable "alb_logging_bucket" {}

variable "domain" {}
data "aws_route53_zone" "hosted_zone_id" {
  name = var.domain
}

variable "dns_config" {
  type = object({
    hostname       = string
    api_hostname   = string
    admin_hostname = string
  })
}

variable "ecs_cluster_config" {
  type = object({
    enable = bool
  })
}

variable "ecr_names" {
  description = "Map of ECR names"
  type        = map(string)
  default = {
    "authentication-api" = "authentication-api"
    "blockchain-api"     = "blockchain-api"
    "card-api"           = "card-api"
    "notification-api"   = "notification-api"
    "reporting-api"      = "reporting-api"
    "transaction-api"    = "transaction-api"
    "utility-api"        = "utility-api"
    "users-api"          = "users-api"
    "admin-panel-api"    = "admin-panel-api"
    "aml-tron"           = "aml-tron"
    "crypto-api"         = "crypto-api"
    "hello-world"        = "hello-world"
    "account-api"        = "account-api"
    "transaction-listener" = "transaction-listener"
  }
}

variable "image_tag" {
  type = object({
    notification = string
    account_api  = string
    authentication_api = string
    blockchain_api = string
    card_api = string
    crypto_api = string
    reporting_api = string
    transaction_api = string
    transaction_listener = string
    users_api = string
    utility_api = string
  })
}


variable "dynamodb_crypto_transaction_listener_arn" {}
variable "secret_manager" {}
variable "trongrid_secret_arn" {}
variable "sqs" {}
variable "lambda" {}