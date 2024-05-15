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
}

module "VPC" {
  source  = "./modules/network"
  network = var.network
  network_config = {
    replica_number  = 3
    gateway_enabled = true
  }
  # iam_role_arn                = module.IAM_Role.vpc_log
  # log_bucket                  = module.S3.vpc_bucket_arn
}

module "application" {
  source             = "./modules/application"
  network            = module.VPC
  alb_logging_bucket = module.S3.alb_log.id
  domain             = var.general_config.domain
  dns_config         = var.dns_config
  ecs_cluster_config = var.ecs_cluster_config
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
  lambda_code = {
    s3_bucket               = "${var.s3_bucket.aml_code}-${var.general_config.env}"
    websocket_connect_s3key = var.lambda_code.websocket_connect_s3key
    elliptic_s3key          = var.lambda_code.elliptic_s3key
  }
}
