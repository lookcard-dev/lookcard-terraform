terraform {
  backend "s3" {
    bucket         = "lookcard-terraform-backend-development"
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
  source = "./modules/secret-manager"
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
  lookcard_rds_password = module.secret-manager.rds_password_secret
}

module "VPC" {
  source  = "./modules/network"
  network = var.network
  network_config = {
    replica_number  = 1
    gateway_enabled = true
  }
}

module "application" {
  source             = "./modules/application"
  alb_logging_bucket = module.S3.alb_log.id
  domain             = var.general_config.domain
  dns_config         = var.dns_config
  ecs_cluster_config = var.ecs_cluster_config
  network = {
    vpc            = module.VPC.vpc
    private_subnet = module.VPC.private_subnet_ids
    public_subnet  = module.VPC.public_subnet_ids
  }
  image_tag                                = var.image_tag
  sqs                                      = module.sqs
  lambda                                   = module.lambda
  dynamodb_crypto_transaction_listener_arn = module.rds.dynamodb_crypto_transaction_listener_arn
  trongrid_secret_arn                      = module.secret-manager.trongrid_secret_arn
  secret_manager                           = module.secret-manager
  dynamodb_config_api_config_data_name     = module.rds.dynamodb_config_api_config_data_name
  dynamodb_config_api_config_data_arn      = module.rds.dynamodb_config_api_config_data_arn
  lookcard_api_domain                      = module.application.lookcard_api_domain
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

module "sqs" {
  source = "./modules/sqs"
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
  lambda_code_s3_bucket          = "${var.s3_bucket.aml_code}-${var.general_config.env}"
  lambda_code_data_process_s3key = var.lambda_code.data_process_s3key
  sqs                            = module.sqs
  secret_manager                 = module.secret-manager
  dynamodb_table_arn             = module.rds.dynamodb_table_arn
}

module "elasticache" {
  source = "./modules/elasticache"
  # aws_provider          = { region = "ap-southeast-1" }
  network = {
    vpc             = module.VPC.vpc
    private_subnet  = module.VPC.private_subnet_ids
    public_subnet   = module.VPC.public_subnet_ids
    database_subnet = module.VPC.database_subnet_ids
  }
}

module "vpc-endpoint" {
  source = "./modules/vpc-endpoint"
  # aws_provider          = { region = "ap-southeast-1" }
  network = {
    vpc            = module.VPC.vpc
    private_subnet = module.VPC.private_subnet_ids
    public_subnet  = module.VPC.public_subnet_ids
  }
  rt_private_id = module.VPC.rt_private_id[0]
}
