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
  source                    = "./modules/network"
  vpc_cidr                  = var.network.vpc_cidr
  public_subnet_cidr_list   = var.network.public_subnet_cidr_list
  private_subnet_cidr_list  = var.network.private_subnet_cidr_list
  database_subnet_cidr_list = var.network.database_subnet_cidr_list
  isolated_subnet_cidr_list = var.network.isolated_subnet_cidr_list
  network_config = {
    replica_number  = 3
    gateway_enabled = true
  }
  # iam_role_arn                = module.IAM_Role.vpc_log
  # log_bucket                  = module.S3.vpc_bucket_arn
}

module "dns" {
  source                = "./modules/dns-config"
  vpc_id                = module.VPC.vpc
  # alb_route             = module.ECS.alb_dns_name
  host_name             = "${var.dns_config.host_name}.${var.general_config.domain}"
  api_host_name         = "${var.dns_config.api_host_name}.${var.general_config.domain}"
  admin_panel_host_name = "${var.dns_config.admin_host_name}.${var.general_config.domain}"

}
