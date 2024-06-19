
variable "general_config" {
  type = object({
    env    = string
    domain = string
  })
}
variable "dns_config" {
  type = object({
    api_hostname   = string
    admin_hostname = string
    hostname       = string
  })
}
variable "aws_provider" {
  type = object({
    region     = string
    account_id = string
  })
}

variable "lambda_code" {
  type = object({
    websocket_connect_s3key    = string
    websocket_disconnect_s3key = string
    data_process_s3key         = string
    elliptic_s3key             = string
    push_message_s3key         = string
    push_notification_s3key    = string
    withdrawal_s3key           = string
  })
}
variable "network" {
  type = object({
    vpc_cidr                  = string
    public_subnet_cidr_list   = list(string)
    private_subnet_cidr_list  = list(string)
    database_subnet_cidr_list = list(string)
    isolated_subnet_cidr_list = list(string)
  })
}
variable "s3_bucket" {
  type = object({
    ekyc_data          = string
    alb_log            = string
    cloudfront_log     = string
    vpc_flow_log       = string
    aml_code           = string
    front_end_endpoint = string
  })
}

variable "ecs_cluster_config" {
  type = object({
    enable = bool
  })
}

variable "sns_subscriptions_email" {
  type = list(string)
}

variable "env" {
  default = "testing"
}

variable "env_secrets" {
  description = "A map of secrets to store in the env secret"
  type        = map(string)
  sensitive   = true
}

variable "notification_env_secrets" {
  description = "A map of secrets to store in the env secret"
  type        = map(string)
  sensitive   = true
}

variable "tron_secrets" {
  description = "A map of secrets to store in the env secret"
  type        = map(string)
  sensitive   = true
}

variable "coinranking_secrets" {
  description = "A map of secrets to store in the env secret"
  type        = map(string)
  sensitive   = true
}

variable "crypto_api_worker_wallet_secrets" {
  description = "A map of secrets to store in the env secret"
  type        = map(string)
  sensitive   = true
}

variable "elliptic_secrets" {
  description = "A map of secrets to store in the env secret"
  type        = map(string)
  sensitive   = true
}
variable "reap_secrets" {
  description = "A map of secrets to store in the env secret"
  type        = map(string)
  sensitive   = true
}

variable "did_processor_lambda_secrets" {
  description = "A map of secrets to store in the env secret"
  type        = map(string)
  sensitive   = true
}

variable "token_secrets" {
  description = "A map of secrets to store in the env secret"
  type        = map(string)
  sensitive   = true
}

variable "aml_env_secrets" {
  description = "A map of secrets to store in the env secret"
  type        = map(string)
  sensitive   = true
}

variable "aggregator_env_secrets" {
  description = "A map of secrets to store in the env secret"
  type        = map(string)
  sensitive   = true
}

variable "db_secrets" {
  description = "A map of secrets to store in the env secret"
  type        = map(string)
  sensitive   = true
}

variable "firebase_secrets" {
  description = "A map of secrets to store in the env secret"
  type        = map(string)
  sensitive   = true
}

variable "crypto_api_env_secrets" {
  description = "A map of secrets to store in the env secret"
  type        = map(string)
  sensitive   = true
}

variable "secret_arns" {
  description = "List of ARN for Secrets Manager"
  type        = list(string)
}

























