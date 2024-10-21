variable "network" {
  description = "Network configuration"
  type = object({
    vpc                     = string
    private_subnet          = list(string)
    public_subnet           = list(string)
    public_subnet_cidr_list = list(string)
  })
}
variable "alb_logging_bucket" {}
data "aws_caller_identity" "current" {}

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
    "authentication-api"    = "authentication-api"
    "blockchain-api"        = "blockchain-api"
    "card-api"              = "card-api"
    "notification-api"      = "notification-api"
    "reporting-api"         = "reporting-api"
    "transaction-api"       = "transaction-api"
    "utility-api"           = "utility-api"
    "users-api"             = "users-api"
    "user-api"              = "user-api"
    "admin-panel-api"       = "admin-panel-api"
    "aml-tron"              = "aml-tron"
    "crypto-api"            = "crypto-api"
    "hello-world"           = "hello-world"
    "account-api"           = "account-api"
    "transaction-listener"  = "transaction-listener"
    "profile-api"           = "profile-api"
    "config-api"            = "config-api"
    "data-api"              = "data-api"
    "notification-v2-api"   = "notification-v2-api"
    "authentication-v2-api" = "authentication-v2-api"
    "crypto-listener"       = "crypto-listener"
    "referral-api"          = "referral-api"
  }
}

variable "image_tag" {}
variable "dynamodb_crypto_transaction_listener_arn" {}
variable "dynamodb_profile_data_table_name" {}
variable "secret_manager" {}
variable "trongrid_secret_arn" {}
variable "database_secret_arn" {}
variable "firebase_secret_arn" {}
variable "get_block_secret_arn" {}
variable "sqs" {}
variable "lambda" {}
variable "dynamodb_config_api_config_data_name" {}
variable "dynamodb_config_api_config_data_arn" {}
variable "lookcard_api_domain" {}
variable "env_tag" {}
variable "acm" {}
variable "kms" {}
variable "s3_data_bucket_name" {}
variable "dynamodb_data_tb_name" {}
variable "rds_aurora_postgresql_writer_endpoint" {}
variable "rds_aurora_postgresql_reader_endpoint" {}
variable "redis_host" {}
# variable "kms_data_generator_key_arn" {}
# variable "kms_data_encryption_key_alpha_arn" {}