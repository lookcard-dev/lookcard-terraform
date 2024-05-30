

variable "network" {}

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
  }
}
