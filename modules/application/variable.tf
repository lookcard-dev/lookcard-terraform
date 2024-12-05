variable "network" {
  description = "Network configuration"
  type = object({
    vpc                     = string
    private_subnet          = list(string)
    public_subnet           = list(string)
    public_subnet_cidr_list = list(string)
  })
}
variable "network_config" {}

# variable "alb_logging_bucket" {}
data "aws_caller_identity" "current" {}

variable "domain" {}
data "aws_route53_zone" "hosted_zone_id" {
  name = var.domain
}


variable "dns_config" {
  type = object({
    hostname       = string
    api_hostname   = string
    admin_hostname           = string
    sumsub_webhook_hostname = string
    reap_webhook_hostname   = string
    firebase_webhook_hostname = string
    fireblocks_webhook_hostname = string
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
    "blockchain-api"       = "blockchain-api"
    "card-api"             = "card-api"
    "notification-api"     = "notification-api"
    "reporting-api"        = "reporting-api"
    "transaction-api"      = "transaction-api"
    "utility-api"          = "utility-api"
    "users-api"            = "users-api"
    "user-api"             = "user-api"
    "admin-panel-api"      = "admin-panel-api"
    "aml-tron"             = "aml-tron"
    "crypto-api"           = "crypto-api"
    "hello-world"          = "hello-world"
    "account-api"          = "account-api"
    "transaction-listener" = "transaction-listener"
    "profile-api"          = "profile-api"
    "config-api"           = "config-api"
    "data-api"             = "data-api"
    "notification-v2-api"  = "notification-v2-api"
    "crypto-listener"      = "crypto-listener"
    "referral-api"         = "referral-api"
    "reap-proxy"           = "reap-proxy"
    "authentication-api"   = "authentication-api"
    "verification-api"     = "verification-api"
    "reseller-api"         = "reseller-api"
    "apigw-authorizer"     = "apigw-authorizer"
    "reap-webhook"         = "reap-webhook"

    #v2 Lambda Function
    "account-statement-generator" = "account-statement-generator"
    "account-balance-snapshot-processor" = "account-balance-snapshot-processor"
    "card-balance-snapshot-processor" = "card-balance-snapshot-processor"
    "card-transaction-reconciliation-processor" = "card-transaction-reconciliation-processor"
    "individual-card-statement-generator" = "individual-card-statement-generator"
    "individual-card-payment-notification-processor" = "individual-card-payment-notification-processor"
    "individual-card-finance-charge-processor" = "individual-card-finance-charge-processor"
    "cryptocurrency-sweep-processor" = "cryptocurrency-sweep-processor"
    "cryptocurrency-batch-sweep-processor" = "cryptocurrency-batch-sweep-processor"
    "cryptocurrency-withdrawal-processor" = "cryptocurrency-withdrawal-processor"
    "notification-dispatcher" = "notification-dispatcher"
    "firebase-authorizer"  = "firebase-authorizer"
    "sumsub-webhook"       = "sumsub-webhook"
    "fireblocks-webhook"   = "fireblocks-webhook"
  }
}

variable "image_tag" {}
variable "secret_manager" {}
variable "trongrid_secret_arn" {}
variable "database_secret_arn" {}
variable "firebase_secret_arn" {}
variable "get_block_secret_arn" {}
# variable "sqs" {}
# variable "lambda" {}
# variable "lookcard_api_domain" {}
variable "env_tag" {}
variable "acm" {}
variable "kms" {}
# variable "s3_data_bucket_name" {}
variable "rds_aurora_postgresql_writer_endpoint" {}
variable "rds_aurora_postgresql_reader_endpoint" {}
variable "redis_host" {}
# variable "rds_proxy_host" {}
# variable "rds_proxy_read_host" {}
# variable "kms_data_generator_key_arn" {}
# variable "kms_data_encryption_key_alpha_arn" {}
variable "lookcard_log_bucket_name" {}
# variable "lambda_firebase_authorizer_sg_id" {}
variable "bastion_sg" {}
# variable "lambda_firebase_authorizer" {}

# reseller-portal module
variable "storage" {}
variable "security" {}
variable "reseller_portal_hostname" {}
variable "aws_provider" {}
variable "s3_bucket" {}
# variable "apigw_module" {}
