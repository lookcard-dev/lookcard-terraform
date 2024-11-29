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

module "secret" {
  source = "./modules/secret"
}

module "network" {
  source  = "./modules/network"
  network = var.network
  network_config = {
    replica_number  = 1
    gateway_enabled = false
  }
}

module "application" {
  source             = "./modules/application"
  # alb_logging_bucket = module.S3.alb_log.id
  domain             = var.general_config.domain
  dns_config         = var.dns_config
  ecs_cluster_config = var.ecs_cluster_config
  network = {
    vpc                     = module.network.vpc
    private_subnet          = module.network.private_subnet_ids
    public_subnet           = module.network.public_subnet_ids
    public_subnet_cidr_list = module.network.public_subnet_cidr_lists
  }
  image_tag                                = var.image_tag
  trongrid_secret_arn                      = module.secret.trongrid_secret_arn
  database_secret_arn                      = module.secret.database_secret_arn
  get_block_secret_arn                     = module.secret.get_block_secret_arn
  firebase_secret_arn                      = module.secret.firebase_secret_arn
  secret_manager                           = module.secret
  # lookcard_api_domain                      = module.application.lookcard_api_domain
  env_tag                                  = var.env_tag
  acm                                      = module.certificate
  kms                                      = module.kms
  # s3_data_bucket_name                      = module.S3.accountid_data
  rds_aurora_postgresql_writer_endpoint    = module.storage.rds_aurora_postgresql_writer_endpoint
  rds_aurora_postgresql_reader_endpoint    = module.storage.rds_aurora_postgresql_reader_endpoint
  redis_host                               = module.storage.redis_host
  lookcard_log_bucket_name = var.s3_bucket.lookcard_log
  bastion_sg                       = module.utils.bastion_sg


  # reseller-portal module
  security = module.security
  storage = module.storage
  reseller_portal_hostname    = "${var.dns_config.reseller_portal_hostname}.${var.general_config.domain}"
  aws_provider          = var.aws_provider
  s3_bucket           = module.storage
}

module "certificate" {
  source                  = "./modules/certificate"
  domain                  = var.general_config.domain
  app_hostname            = "${var.dns_config.hostname}.${var.general_config.domain}"
  admin_hostname          = "${var.dns_config.admin_hostname}.${var.general_config.domain}"
  api_hostname            = "${var.dns_config.api_hostname}.${var.general_config.domain}"
  sumsub_webhook_hostname = "${var.dns_config.sumsub_webhook_hostname}.${var.general_config.domain}"
  reap_webhook_hostname   = "${var.dns_config.reap_webhook_hostname}.${var.general_config.domain}"
  firebase_webhook_hostname = "${var.dns_config.firebase_webhook_hostname}.${var.general_config.domain}"
  fireblocks_webhook_hostname = "${var.dns_config.fireblocks_webhook_hostname}.${var.general_config.domain}"
}

# module "cdn" {
#   source                = "./modules/cdn"
#   domain                = var.general_config.domain
#   alternate_domain_name = "${var.dns_config.hostname}.${var.general_config.domain}"
#   alternate_reseller_domain_name = "${var.dns_config.reseller_portal_hostname}.${var.general_config.domain}"
#   origin_s3_bucket      = module.S3.front_end_endpoint
#   cdn_logging_s3_bucket = module.S3.cloudfront_log
#   reseller_portal_bucket = module.S3.reseller_portal_bucket
#   ssl_cert                = module.ssl-cert
#   waf_log                 = module.S3.waf_log
# }


# module "sqs" {
#   source = "./modules/sqs"
# }

# module "lambda" {
#   source            = "./modules/lambda"
#   ddb_websocket_arn = module.rds.ddb_websocket.arn
#   network = {
#     vpc            = module.VPC.vpc
#     private_subnet = module.VPC.private_subnet_ids
#     public_subnet  = module.VPC.public_subnet_ids
#   }
#   vpc_id = module.VPC.vpc
#   lambda_code = {
#     s3_bucket                  = "${var.s3_bucket.aml_code}-${var.general_config.env}"
#     data_process_s3key         = var.lambda_code.data_process_s3key
#     elliptic_s3key             = var.lambda_code.elliptic_s3key
#     websocket_connect_s3key    = var.lambda_code.websocket_connect_s3key
#     websocket_disconnect_s3key = var.lambda_code.websocket_disconnect_s3key
#     push_message_s3key         = var.lambda_code.push_message_s3key
#     push_notification_s3key    = var.lambda_code.push_notification_s3key
#     withdrawal_s3key           = var.lambda_code.withdrawal_s3key
#   }
#   lambda_code_s3_bucket          = "${var.s3_bucket.aml_code}-${var.general_config.env}"
#   lambda_code_data_process_s3key = var.lambda_code.data_process_s3key
#   sqs                            = module.sqs
#   secret_manager                 = module.secret-manager
#   dynamodb_table_arn             = module.rds.dynamodb_table_arn
#   general_config                 = var.general_config
#   image_tag                      = var.image_tag
#   ecr_repository_urls            = module.application.ecr_repository_urls
#   env_tag                        = var.env_tag
# }

# module "elasticache" {
#   source = "./modules/elasticache"
#   network = {
#     vpc             = module.VPC.vpc
#     private_subnet  = module.VPC.private_subnet_ids
#     public_subnet   = module.VPC.public_subnet_ids
#     database_subnet = module.VPC.database_subnet_ids
#   }
# }

# module "vpc-endpoint" {
#   source = "./modules/vpc-endpoint"
#   network = {
#     vpc            = module.VPC.vpc
#     private_subnet = module.VPC.private_subnet_ids
#     public_subnet  = module.VPC.public_subnet_ids
#   }
#   rt_private_id = module.VPC.rt_private_id[0]
# }

module "kms" {
  source = "./modules/kms"
}

# module "bastion" {
#   source = "./modules/bastion"
#   network = {
#     vpc            = module.network.vpc
#     private_subnet = module.network.private_subnet_ids
#     public_subnet  = module.network.public_subnet_ids
#   }
# }

module "storage" {
  source                  = "./modules/storage"
  s3_bucket               = var.s3_bucket
  environment             = var.general_config
  aws_provider            = var.aws_provider
  secret_manager          = module.secret
  network = {
    vpc                     = module.network.vpc
    private_subnet          = module.network.private_subnet_ids
    public_subnet           = module.network.public_subnet_ids
    database_subnet         = module.network.database_subnet_ids
  }
}

module "security" {
  source = "./modules/security"
  waf_logging_s3_bucket = module.storage.waf_log_bucket.arn
}

module "utils" {
  source = "./modules/utils"
  network = {
    vpc            = module.network.vpc
    private_subnet = module.network.private_subnet_ids
    public_subnet  = module.network.public_subnet_ids
  }
  syn_canary_s3_bucket = module.storage.cloudwatch_syn_canaries
  sns_subscriptions_email = var.sns_subscriptions_email
}

module "apigw" {
  source = "./modules/apigw"
  acm = module.certificate
  application = module.application
  env_tag = var.env_tag
  dns_config = var.dns_config
  domain = var.general_config.domain
}
