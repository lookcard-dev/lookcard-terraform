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
  source             = "./modules/S3"
  environment        = var.general_config.env
  ekyc_data          = var.s3_bucket.ekyc_data
  alb_log            = var.s3_bucket.alb_log
  cloudfront_log     = var.s3_bucket.cloudfront_log
  vpc_flow_log       = var.s3_bucket.vpc_flow_log
  aml_code           = var.s3_bucket.aml_code
  front_end_endpoint = var.front_end_endpoint
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
}

# module "dns" {
#   source                = "./modules/dns-config"
#   vpc_id                = module.VPC.vpc
#   # alb_route             = module.ECS.alb_dns_name
#   host_name             = "${var.dns_config.host_name}.${var.general_config.domain}"
#   api_host_name         = "${var.dns_config.api_host_name}.${var.general_config.domain}"
#   admin_panel_host_name = "${var.dns_config.admin_host_name}.${var.general_config.domain}"
# }
