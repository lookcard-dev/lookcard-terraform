terraform {
  backend "s3" {
    bucket         = "lookcard-testing-tf"
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