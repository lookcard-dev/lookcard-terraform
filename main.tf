terraform {
  backend "s3" {
    bucket         = "lookcard-terraform-backend-testing"
    key            = "state/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "lookcard-tf-lockid"
  }
}

provider "aws" {
  region = var.aws_provider.region
}

module "secret-manager" {
  source                           = "./modules/secret-manager"
  env_secrets                      = var.env_secrets
  notification_env_secrets         = var.notification_env_secrets
  tron_secrets                     = var.tron_secrets
  coinranking_secrets              = var.coinranking_secrets
  crypto_api_worker_wallet_secrets = var.crypto_api_worker_wallet_secrets
  elliptic_secrets                 = var.elliptic_secrets
  reap_secrets                     = var.reap_secrets
  did_processor_lambda_secrets     = var.did_processor_lambda_secrets
  token_secrets                    = var.token_secrets
  aml_env_secrets                  = var.aml_env_secrets
  aggregator_env_secrets           = var.aggregator_env_secrets
  db_secrets                       = var.db_secrets
  firebase_secrets                 = var.firebase_secrets
  crypto_api_env_secrets           = var.crypto_api_env_secrets
}

module "S3" {
  source             = "./modules/s3"
  environment        = var.general_config.env
  ekyc_data          = var.s3_bucket.ekyc_data
  alb_log            = var.s3_bucket.alb_log
  cloudfront_log     = var.s3_bucket.cloudfront_log
  vpc_flow_log       = var.s3_bucket.vpc_flow_log
  aml_code           = var.s3_bucket.aml_code
  front_end_endpoint = var.s3_bucket.front_end_endpoint
}

module "rds" {
  source = "./modules/database"
  network = {
    vpc            = module.VPC.vpc
    private_subnet = module.VPC.private_subnet_ids
    public_subnet  = module.VPC.public_subnet_ids
  }
  lookcard_db_secret    = module.secret-manager.lookcard_db_secret
  lookcard_rds_password = var.lookcard_rds_password

}

module "VPC" {
  source  = "./modules/network"
  network = var.network
  network_config = {
    replica_number  = 1
    gateway_enabled = true
  }
  # iam_role_arn                = module.IAM_Role.vpc_log
  # log_bucket                  = module.S3.vpc_bucket_arn
}

module "application" {
  source             = "./modules/application"
  alb_logging_bucket = module.S3.alb_log.id
  domain             = var.general_config.domain
  dns_config         = var.dns_config
  ecs_cluster_config = var.ecs_cluster_config
  # authentication_tgp_arn = module.application.authentication.authentication_tgp_arn
  secret_arns           = var.secret_arns
  crypto_api_secret_arn = module.secret-manager.crypto_api_secret_arn
  firebase_secret_arn   = module.secret-manager.firebase_secret_arn
  elliptic_secret_arn   = module.secret-manager.elliptic_secret_arn
  db_secret_secret_arn  = module.secret-manager.db_secret_secret_arn
  env_secrets_arn       = module.secret-manager.env_secrets_arn
  token_secrets_arn     = module.secret-manager.token_secrets_arn
  network = {
    vpc            = module.VPC.vpc
    private_subnet = module.VPC.private_subnet_ids
    public_subnet  = module.VPC.public_subnet_ids
  }
  sqs_withdrawal                           = module.lambda.withdrawal_sqs
  lookcard_notification_sqs_url            = module.lambda.lookcard_notification_sqs_url
  crypto_fund_withdrawal_sqs_url           = module.lambda.crypto_fund_withdrawal_sqs_url
  push_message_invoke                      = module.lambda.push_message_web_invoke
  push_message_web_function                = module.lambda.push_message_web_function
  web_socket_function                      = module.lambda.web_socket_function
  web_socket_invoke                        = module.lambda.web_socket_invoke
  web_socket_disconnect_invoke             = module.lambda.web_socket_disconnect_invoke
  web_socket_disconnect_function           = module.lambda.web_socket_disconnect_function
  aggregator_tron_sqs_url                  = module.lambda.aggregator_tron_sqs_url
  trongrid_secret_arn                      = module.secret-manager.trongrid_secret_arn
  dynamodb_crypto_transaction_listener_arn = module.rds.dynamodb_crypto_transaction_listener_arn
  aggregator_tron_sqs_arn                  = module.lambda.aggregator_tron_sqs_arn
}

module "ssl-cert" {
  source         = "./modules/ssl-cert"
  domain         = var.general_config.domain
  app_hostname   = "${var.dns_config.hostname}.${var.general_config.domain}"
  admin_hostname = "${var.dns_config.admin_hostname}.${var.general_config.domain}"
  api_hostname   = "${var.dns_config.api_hostname}.${var.general_config.domain}"
}

module "cdn" {
  source                = "./modules/cdn"
  domain                = var.general_config.domain
  app_hostname_cert     = module.ssl-cert.acm_app
  alternate_domain_name = "${var.dns_config.hostname}.${var.general_config.domain}"
  origin_s3_bucket      = module.S3.front_end_endpoint
  cdn_logging_s3_bucket = module.S3.cloudfront_log
}

module "sns_topic" {
  source                  = "./modules/monitor"
  sns_subscriptions_email = var.sns_subscriptions_email
}

module "lambda" {
  source            = "./modules/lambda"
  ddb_websocket_arn = module.rds.ddb_websocket.arn
  network = {
    vpc            = module.VPC.vpc
    private_subnet = module.VPC.private_subnet_ids
    public_subnet  = module.VPC.public_subnet_ids
  }
  vpc_id = module.VPC.vpc
  lambda_code = {
    s3_bucket                  = "${var.s3_bucket.aml_code}-${var.general_config.env}"
    data_process_s3key         = var.lambda_code.data_process_s3key
    elliptic_s3key             = var.lambda_code.elliptic_s3key
    websocket_connect_s3key    = var.lambda_code.websocket_connect_s3key
    websocket_disconnect_s3key = var.lambda_code.websocket_disconnect_s3key
    push_message_s3key         = var.lambda_code.push_message_s3key
    push_notification_s3key    = var.lambda_code.push_notification_s3key
    withdrawal_s3key           = var.lambda_code.withdrawal_s3key
  }
  secret_arn_list    = module.secret-manager.secret_arns
  dynamodb_table_arn = module.rds.dynamodb_table_arn
  # web_scoket_iam = 
}
