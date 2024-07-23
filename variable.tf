
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

variable "image_tag" {
  type = object({
    notification         = string
    account_api          = string
    authentication_api   = string
    blockchain_api       = string
    card_api             = string
    crypto_api           = string
    reporting_api        = string
    transaction_listener = string
    transaction_api      = string
    users_api            = string
    utility_api          = string
    profile_api          = string
    config_api           = string
    data_api             = string
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
    ekyc_data               = string
    alb_log                 = string
    cloudfront_log          = string
    vpc_flow_log            = string
    aml_code                = string
    front_end_endpoint      = string
    cloudwatch_syn_canaries = string
    accountid_data         = string
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

variable "env_tag" {
  default = "Develop"
}




