

# variable "network" {}
variable "network" {
  description = "Network configuration"
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}
# variable "cluster" {}
variable "alb_logging_bucket" {}
# variable "env" {}

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
  }
}

variable "sqs_withdrawal" {}

variable "lookcard_notification_sqs_url" {}
variable "crypto_fund_withdrawal_sqs_url" {}
variable "secret_arns" {}
variable "crypto_api_secret_arn" {}

variable "firebase_secret_arn" {}
variable "elliptic_secret_arn" {}
variable "db_secret_secret_arn" {}

# variable "authentication_tgp_arn" {}
variable "push_message_invoke" {}
variable "push_message_web_function" {}
variable "web_socket_invoke" {}
variable "web_socket_function" {}
variable "web_socket_disconnect_invoke" {}
variable "web_socket_disconnect_function" {}
