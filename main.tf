locals {
  is_github_actions = sensitive(try(tobool(coalesce(var.github_actions, "false")), false))
}

terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.dns, aws.us_east_1]
    }
  }
}

terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.0"
    }
  }
}

variable "github_actions" {
  type    = string
  default = "false"
}

terraform {
  backend "s3" {
    bucket         = "390844786071-lookcard-terraform"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "terraform"
  }
}

provider "aws" {
  region     = local.aws_provider.application.region
  profile    = local.is_github_actions ? null : local.aws_provider.application.profile
  access_key = var.APPLICATION__AWS_ACCESS_KEY_ID
  secret_key = var.APPLICATION__AWS_SECRET_ACCESS_KEY
  token      = var.APPLICATION__AWS_SESSION_TOKEN

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

provider "aws" {
  alias      = "us_east_1"
  region     = "us-east-1"
  profile    = local.is_github_actions ? null : local.aws_provider.application.profile
  access_key = var.APPLICATION__AWS_ACCESS_KEY_ID
  secret_key = var.APPLICATION__AWS_SECRET_ACCESS_KEY
  token      = var.APPLICATION__AWS_SESSION_TOKEN

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

provider "aws" {
  alias      = "dns"
  region     = "us-east-1"
  profile    = local.is_github_actions ? null : local.aws_provider.dns.profile
  access_key = var.DNS__AWS_ACCESS_KEY_ID
  secret_key = var.DNS__AWS_SECRET_ACCESS_KEY
  token      = var.DNS__AWS_SESSION_TOKEN

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

module "network" {
  source              = "./modules/network"
  network             = var.network
  aws_provider        = local.aws_provider.application
  runtime_environment = var.runtime_environment
  providers = {
    aws.dns = aws.dns
  }
}

module "security" {
  source              = "./modules/security"
  domain              = var.domain
  aws_provider        = local.aws_provider.application
  runtime_environment = var.runtime_environment

  providers = {
    aws.dns = aws.dns
  }
}

module "storage" {
  source              = "./modules/storage"
  aws_provider        = local.aws_provider.application
  runtime_environment = var.runtime_environment
  vpc_id              = module.network.vpc_id
  subnet_ids = {
    datacache = module.network.database_subnet_ids
    datastore = module.network.database_subnet_ids
  }
  components = local.components
  depends_on = [module.security, module.network]
}

module "compute" {
  source              = "./modules/compute"
  aws_provider        = local.aws_provider.application
  runtime_environment = var.runtime_environment
  vpc_id              = module.network.vpc_id
  subnet_ids          = module.network.private_subnet_ids
  depends_on          = [module.network]
}

module "application" {
  source              = "./modules/application"
  aws_provider        = local.aws_provider.application
  runtime_environment = var.runtime_environment
  depends_on          = [module.network, module.storage, module.compute, module.security]

  network = {
    vpc_id              = module.network.vpc_id
    private_subnet_ids  = module.network.private_subnet_ids
    public_subnet_ids   = module.network.public_subnet_ids
    isolated_subnet_ids = module.network.isolated_subnet_ids
  }

  cluster_ids = {
    listener              = module.compute.listener_cluster_id
    composite_application = module.compute.composite_application_cluster_id
    core_application      = module.compute.core_application_cluster_id
    administrative        = module.compute.administrative_cluster_id
    cronjob               = module.compute.cronjob_cluster_id
  }

  namespace_id = module.network.cloudmap_namespace_id

  datastore = {
    writer_endpoint = module.storage.datastore_writer_endpoint
    reader_endpoint = module.storage.datastore_reader_endpoint
  }

  datacache = {
    endpoint = module.storage.datacache_endpoint
  }

  components = local.components

  kms_key_arns = {
    data = {
      generator  = module.security.data_generator_key_arn
      encryption = module.security.data_encryption_key_arn
    }
    crypto = {
      worker = {
        alpha = module.security.crypto_worker_alpha_key_arn
      }
      liquidity = module.security.crypto_liquidity_key_arn
    }

    depends_on = [module.network, module.security]
  }

  domain = var.domain

  elb = {
    application_load_balancer_arn               = module.network.application_load_balancer_arn
    network_load_balancer_arn                   = module.network.network_load_balancer_arn
    application_load_balancer_dns_name          = module.network.application_load_balancer_dns_name
    network_load_balancer_dns_name              = module.network.network_load_balancer_dns_name
    application_load_balancer_http_listener_arn = module.network.application_load_balancer_http_listener_arn
  }

  api_gateway = {
    vpc_link_arn = module.network.api_gateway_vpc_link_arn
    vpc_link_id  = module.network.api_gateway_vpc_link_id
  }

  providers = {
    aws.dns       = aws.dns
    aws.us_east_1 = aws.us_east_1
  }
}

module "monitor" {
  source = "./modules/monitor"

  aws_provider        = local.aws_provider.application
  runtime_environment = var.runtime_environment
}

# module "utils" {
#   source = "./modules/utils"
#   network = {
#     vpc            = module.network.vpc
#     private_subnet = module.network.private_subnet_ids
#     public_subnet  = module.network.public_subnet_ids
#   }
#   syn_canary_s3_bucket = module.storage.cloudwatch_syn_canaries
#   sns_subscriptions_email = var.sns_subscriptions_email
# }

# module "security" {
#   source = "./modules/security"
#   waf_logging_s3_bucket = module.storage.waf_log_bucket.arn
#   # reseller_api_stage = module.apigw.reseller_api_stage
# }


# module "apigw" {
#   source = "./modules/apigw"
#   acm = module.certificate
#   application = module.application
#   env_tag = var.env_tag
#   dns_config = var.dns_config
#   domain = var.general_config.domain
#   security_module = module.security
# }



# module "application" {
#   source             = "./modules/application"
#   # alb_logging_bucket = module.S3.alb_log.id
#   domain             = var.general_config.domain
#   dns_config         = var.dns_config
#   ecs_cluster_config = var.ecs_cluster_config
#   network = {
#     vpc                     = module.network.vpc
#     private_subnet          = module.network.private_subnet_ids
#     public_subnet           = module.network.public_subnet_ids
#     public_subnet_cidr_list = module.network.public_subnet_cidr_lists
#   }
#   image_tag                                = var.image_tag
#   trongrid_secret_arn                      = module.secret.trongrid_secret_arn
#   database_secret_arn                      = module.secret.database_secret_arn
#   get_block_secret_arn                     = module.secret.get_block_secret_arn
#   firebase_secret_arn                      = module.secret.firebase_secret_arn
#   secret_manager                           = module.secret
#   # lookcard_api_domain                      = module.application.lookcard_api_domain
#   env_tag                                  = var.env_tag
#   acm                                      = module.certificate
#   kms                                      = module.kms
#   # s3_data_bucket_name                      = module.S3.accountid_data
#   rds_aurora_postgresql_writer_endpoint    = module.storage.rds_aurora_postgresql_writer_endpoint
#   rds_aurora_postgresql_reader_endpoint    = module.storage.rds_aurora_postgresql_reader_endpoint
#   redis_host                               = module.storage.redis_host
#   lookcard_log_bucket_name = var.s3_bucket.lookcard_log
#   bastion_sg                       = module.utils.bastion_sg


#   # reseller-portal module
#   security = module.security
#   storage = module.storage
#   reseller_portal_hostname    = "${var.dns_config.reseller_portal_hostname}.${var.general_config.domain}"
#   aws_provider          = var.aws_provider
#   s3_bucket           = module.storage
#   network_config = var.network
#   # apigw_module = module.apigw
# }

# module "certificate" {
#   source                  = "./modules/certificate"
#   domain                  = var.general_config.domain
#   app_hostname            = "${var.dns_config.hostname}.${var.general_config.domain}"
#   admin_hostname          = "${var.dns_config.admin_hostname}.${var.general_config.domain}"
#   api_hostname            = "${var.dns_config.api_hostname}.${var.general_config.domain}"
#   sumsub_webhook_hostname = "${var.dns_config.sumsub_webhook_hostname}.${var.general_config.domain}"
#   reap_webhook_hostname   = "${var.dns_config.reap_webhook_hostname}.${var.general_config.domain}"
#   firebase_webhook_hostname = "${var.dns_config.firebase_webhook_hostname}.${var.general_config.domain}"
#   fireblocks_webhook_hostname = "${var.dns_config.fireblocks_webhook_hostname}.${var.general_config.domain}"
#   apigw_reseller_hostname = "${var.dns_config.apigw_reseller_hostname}.${var.general_config.domain}"
#   webhook_hostname = "${var.dns_config.webhook_hostname}.${var.general_config.domain}"
# }

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


# module "bastion" {
#   source = "./modules/bastion"
#   network = {
#     vpc            = module.network.vpc
#     private_subnet = module.network.private_subnet_ids
#     public_subnet  = module.network.public_subnet_ids
#   }
# }






