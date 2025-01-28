# resource "aws_secretsmanager_secret" "database_secret"

module "xray-daemon" {
  source = "./00-xray-daemon"
  aws_provider = var.aws_provider
  name = "xray-daemon"
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.core_application
  namespace_id = var.namespace_id
  network = var.network
  allow_to_security_group_ids = []
}

module "profile-api" {
  source = "./01-profile-api"
  aws_provider = var.aws_provider
  name = "profile-api"
  image_tag = var.components["profile-api"].image_tag
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.core_application
  namespace_id = var.namespace_id
  network = var.network
  allow_to_security_group_ids = [module.xray-daemon.security_group_id]
}

module "data-api" {
  source = "./02-data-api"
  aws_provider = var.aws_provider
  name = "data-api"
  image_tag = var.components["data-api"].image_tag
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.core_application
  namespace_id = var.namespace_id
  network = var.network
  allow_to_security_group_ids = [module.xray-daemon.security_group_id]
  kms_key_arns = var.kms_key_arns
}

module "config-api" {
  source = "./03-config-api"
  aws_provider = var.aws_provider
  name = "config-api"
  image_tag = var.components["config-api"].image_tag
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.core_application
  namespace_id = var.namespace_id
  network = var.network
  allow_to_security_group_ids = [module.xray-daemon.security_group_id]
}

module "user-api" {
  source = "./04-user-api"
  aws_provider = var.aws_provider
  name = "user-api"
  image_tag = var.components["user-api"].image_tag
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.core_application
  namespace_id = var.namespace_id
  network = var.network
  allow_to_security_group_ids = [
    module.xray-daemon.security_group_id,
    module.profile-api.security_group_id,
    module.data-api.security_group_id
  ]
  datacache = var.datacache
  datastore = var.datastore
}

module "account-api" {
  source = "./05-account-api"
  aws_provider = var.aws_provider
  name = "account-api"
  image_tag = var.components["account-api"].image_tag
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.core_application
  namespace_id = var.namespace_id
  network = var.network
  allow_to_security_group_ids = [
    module.xray-daemon.security_group_id,
    module.config-api.security_group_id,
    module.profile-api.security_group_id,
    module.data-api.security_group_id
  ]
  datacache = var.datacache
  datastore = var.datastore
}

module "crypto-api" {
  source = "./06-crypto-api"
  aws_provider = var.aws_provider
  name = "crypto-api"
  image_tag = var.components["crypto-api"].image_tag
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.core_application
  namespace_id = var.namespace_id
  network = var.network
  allow_to_security_group_ids = [
    module.xray-daemon.security_group_id,
    module.config-api.security_group_id,
    module.profile-api.security_group_id,
    module.data-api.security_group_id,
    module.account-api.security_group_id
  ]
  datacache = var.datacache
  datastore = var.datastore
  kms_key_arns = var.kms_key_arns
}

module "crypto-listener" {
  source = "./07-crypto-listener"
  aws_provider = var.aws_provider
  name = "crypto-listener"
  image_tag = var.components["crypto-listener"].image_tag
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.listener
  network = var.network
  allow_to_security_group_ids = [
    module.xray-daemon.security_group_id,
    module.crypto-api.security_group_id
  ]
  datastore = var.datastore
  datacache = var.datacache
}

module "crypto-processor" {
  source = "./08-crypto-processor"
  aws_provider = var.aws_provider
  name = "crypto-processor"
  image_tag = var.components["crypto-processor"].image_tag
  runtime_environment = var.runtime_environment
  network = var.network
  allow_to_security_group_ids = [
    module.xray-daemon.security_group_id,
    module.crypto-api.security_group_id,
    module.account-api.security_group_id,
    module.profile-api.security_group_id,
    module.config-api.security_group_id
  ]
}

module "authentication-api" {
  source = "./09-authentication-api"
  aws_provider = var.aws_provider
  name = "authentication-api"
  image_tag = var.components["authentication-api"].image_tag
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.core_application
  namespace_id = var.namespace_id
  network = var.network
  allow_to_security_group_ids = [
    module.xray-daemon.security_group_id
  ]
}

module "verification-api" {
  source = "./10-verification-api"
  aws_provider = var.aws_provider
  name = "verification-api"
  image_tag = var.components["verification-api"].image_tag
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.core_application
  namespace_id = var.namespace_id
  network = var.network
  allow_to_security_group_ids = [
    module.xray-daemon.security_group_id,
    module.data-api.security_group_id,
  ]
  datacache = var.datacache
  datastore = var.datastore
}

module "notification-api" {
  source = "./11-notification-api"
  aws_provider = var.aws_provider
  name = "notification-api"
  image_tag = var.components["notification-api"].image_tag
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.core_application
  namespace_id = var.namespace_id
  network = var.network
  allow_to_security_group_ids = [module.xray-daemon.security_group_id]
}

module "referral-api" {
  source = "./12-referral-api"
  aws_provider = var.aws_provider
  name = "referral-api"
  image_tag = var.components["referral-api"].image_tag
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.core_application
  namespace_id = var.namespace_id
  network = var.network
  allow_to_security_group_ids = [module.xray-daemon.security_group_id]
  datastore = var.datastore
  datacache = var.datacache
}

module "domain-api" {
  source = "./13-domain-api"
  aws_provider = var.aws_provider
  name = "domain-api"
  image_tag = var.components["domain-api"].image_tag
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.core_application
  namespace_id = var.namespace_id
  network = var.network
  allow_to_security_group_ids = [module.xray-daemon.security_group_id]
}

module "reseller-api" {
  source = "./14-reseller-api"
  aws_provider = var.aws_provider
  name = "reseller-api"
  image_tag = var.components["reseller-api"].image_tag
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.composite_application
  namespace_id = var.namespace_id
  network = var.network
  allow_to_security_group_ids = [module.xray-daemon.security_group_id]
  datastore = var.datastore
  datacache = var.datacache
}

module "reap-proxy" {
  source = "./15-reap-proxy"
  aws_provider = var.aws_provider
  name = "reap-proxy"
  image_tag = var.components["reap-proxy"].image_tag
  runtime_environment = var.runtime_environment
  cluster_id = var.cluster_ids.core_application
  namespace_id = var.namespace_id
  network = var.network
  allow_to_security_group_ids = [module.xray-daemon.security_group_id]
}

module "firebase-authorizer" {
  source = "./16-firebase-authorizer"
  aws_provider = var.aws_provider
  name = "firebase-authorizer"
  image_tag = var.components["firebase-authorizer"].image_tag
  runtime_environment = var.runtime_environment
  network = var.network
  allow_to_security_group_ids = [
    module.xray-daemon.security_group_id,
    module.authentication-api.security_group_id,
    module.profile-api.security_group_id
  ]
}

# module "crypto-listener" {
#   source = "./crypto-listener"
#   network = {
#     vpc            = var.network.vpc
#     private_subnet = var.network.private_subnet
#     public_subnet  = var.network.public_subnet
#   }
#   image = {
#     url = aws_ecr_repository.look-card["crypto-listener"].repository_url
#     tag = var.image_tag.crypto-listener
#   }
#   vpc_id         = var.network.vpc
#   cluster        = aws_ecs_cluster.listener.arn
#   secret_manager = var.secret_manager
#   # sqs                                      = module.sqs
#   capacity_provider_ec2_arm64_on_demand = aws_ecs_capacity_provider.ec2_arm64_on_demand.name
#   capacity_provider_ec2_amd64_on_demand = aws_ecs_capacity_provider.ec2_amd64_on_demand.name
#   rds_aurora_postgresql_writer_endpoint = var.rds_aurora_postgresql_writer_endpoint
#   rds_aurora_postgresql_reader_endpoint = var.rds_aurora_postgresql_reader_endpoint
#   env_tag                               = var.env_tag
#   # rds_proxy_host                           = var.rds_proxy_host
#   # rds_proxy_read_host                      = var.rds_proxy_read_host
#   bastion_sg = var.bastion_sg
# }

# module "account-api" {
#   source           = "./account-api"
#   default_listener = aws_lb_listener.look-card.arn
#   vpc_id           = var.network.vpc
#   image = {
#     url = aws_ecr_repository.look-card["account-api"].repository_url
#     tag = var.image_tag.account-api
#   }
#   network = {
#     vpc            = var.network.vpc
#     private_subnet = var.network.private_subnet
#     public_subnet  = var.network.public_subnet
#   }
#   lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
#   cluster                 = aws_ecs_cluster.core_application.arn
#   sg_alb_id               = aws_security_group.api_alb_sg.id
#   # lambda                                = var.lambda
#   secret_manager = var.secret_manager
#   # sqs                                   = module.sqs
#   acm                                   = var.acm
#   env_tag                               = var.env_tag
#   redis_host                            = var.redis_host
#   rds_aurora_postgresql_writer_endpoint = var.rds_aurora_postgresql_writer_endpoint
#   rds_aurora_postgresql_reader_endpoint = var.rds_aurora_postgresql_reader_endpoint
#   # rds_proxy_host                        = var.rds_proxy_host
#   # rds_proxy_read_host                   = var.rds_proxy_read_host
#   reseller_api_sg     = module.reseller-api.reseller_api_sg
#   bastion_sg          = var.bastion_sg
#   crypto_api_module   = module.crypto-api
#   reseller_api_module = module.reseller-api
# }

# module "user-api" {
#   source = "./user-api"
#   vpc_id = var.network.vpc
#   image = {
#     url = aws_ecr_repository.look-card["user-api"].repository_url
#     tag = var.image_tag.user-api
#   }
#   network = {
#     vpc            = var.network.vpc
#     private_subnet = var.network.private_subnet
#     public_subnet  = var.network.public_subnet
#   }
#   lookcardlocal_namespace               = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
#   cluster                               = aws_ecs_cluster.core_application.arn
#   secret_manager                        = var.secret_manager
#   sg_alb_id                             = aws_security_group.api_alb_sg.id
#   env_tag                               = var.env_tag
#   redis_host                            = var.redis_host
#   rds_aurora_postgresql_writer_endpoint = var.rds_aurora_postgresql_writer_endpoint
#   rds_aurora_postgresql_reader_endpoint = var.rds_aurora_postgresql_reader_endpoint
#   lambda_firebase_authorizer_sg_id      = module.firebase-authorizer.lambda_firebase_authorizer_sg.id
#   # rds_proxy_host                        = var.rds_proxy_host
#   # rds_proxy_read_host                   = var.rds_proxy_read_host
#   bastion_sg = var.bastion_sg
#   # lambda          = var.lambda
#   reseller_api_sg            = module.reseller-api.reseller_api_sg
#   firebase_authorizer_module = module.firebase-authorizer
#   reseller_module            = module.reseller-api
# }

# module "reap-proxy" {
#   source = "./reap-proxy"
#   vpc_id = var.network.vpc
#   image = {
#     url = aws_ecr_repository.look-card["reap-proxy"].repository_url
#     tag = var.image_tag.reap-proxy
#   }
#   network = {
#     vpc            = var.network.vpc
#     private_subnet = var.network.private_subnet
#     public_subnet  = var.network.public_subnet
#   }
#   lookcardlocal_namespace  = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
#   cluster                  = aws_ecs_cluster.core_application.arn
#   secret_manager           = var.secret_manager
#   sg_alb_id                = aws_security_group.api_alb_sg.id
#   env_tag                  = var.env_tag
#   lookcard_log_bucket_name = var.lookcard_log_bucket_name
#   bastion_sg               = var.bastion_sg
# }

# module "verification-api" {
#   source = "./verification-api"
#   vpc_id = var.network.vpc
#   image = {
#     url = aws_ecr_repository.look-card["verification-api"].repository_url
#     tag = var.image_tag.verification-api
#   }
#   network = {
#     vpc            = var.network.vpc
#     private_subnet = var.network.private_subnet
#     public_subnet  = var.network.public_subnet
#   }
#   lookcardlocal_namespace               = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
#   cluster                               = aws_ecs_cluster.core_application.arn
#   secret_manager                        = var.secret_manager
#   sg_alb_id                             = aws_security_group.api_alb_sg.id
#   env_tag                               = var.env_tag
#   redis_host                            = var.redis_host
#   rds_aurora_postgresql_writer_endpoint = var.rds_aurora_postgresql_writer_endpoint
#   rds_aurora_postgresql_reader_endpoint = var.rds_aurora_postgresql_reader_endpoint
#   bastion_sg                            = var.bastion_sg
#   sumsub_webhook_module                 = module.sumsub-webhook
#   reseller_api_module                   = module.reseller-api
# }

# module "authentication-api" {
#   source = "./authentication-api"
#   vpc_id = var.network.vpc
#   image = {
#     url = aws_ecr_repository.look-card["authentication-api"].repository_url
#     tag = var.image_tag.authentication-api
#   }
#   network = {
#     vpc            = var.network.vpc
#     private_subnet = var.network.private_subnet
#     public_subnet  = var.network.public_subnet
#   }
#   lookcardlocal_namespace          = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
#   cluster                          = aws_ecs_cluster.core_application.arn
#   secret_manager                   = var.secret_manager
#   sg_alb_id                        = aws_security_group.api_alb_sg.id
#   env_tag                          = var.env_tag
#   lambda_firebase_authorizer_sg_id = module.firebase-authorizer.lambda_firebase_authorizer_sg.id
#   bastion_sg                       = var.bastion_sg
#   firebase_authorizer_module       = module.firebase-authorizer
# }

# module "notification-api" {
#   source  = "./notification-api"
#   cluster = aws_ecs_cluster.core_application.arn
#   image = {
#     url = aws_ecr_repository.look-card["notification-api"].repository_url
#     tag = var.image_tag.notification-api
#   }
#   network = {
#     vpc            = var.network.vpc
#     private_subnet = var.network.private_subnet
#     public_subnet  = var.network.public_subnet
#   }
#   secret_manager          = var.secret_manager
#   env_tag                 = var.env_tag
#   sg_alb_id               = aws_security_group.api_alb_sg.id
#   bastion_sg              = var.bastion_sg
#   lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
#   data_api_ecs_svc_sg     = module.data-api.data_api_ecs_svc_sg
# }


# module "profile-api" {
#   source = "./profile-api"
#   # default_listener = aws_lb_listener.look-card.arn
#   cluster = aws_ecs_cluster.core_application.arn
#   network = {
#     vpc            = var.network.vpc
#     private_subnet = var.network.private_subnet
#     public_subnet  = var.network.public_subnet
#   }
#   image = {
#     url = aws_ecr_repository.look-card["profile-api"].repository_url
#     tag = var.image_tag.profile-api
#   }
#   lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
#   secret_manager          = var.secret_manager
#   env_tag                 = var.env_tag
#   # sg_alb_id                        = aws_security_group.api_alb_sg.id
#   referral_api_sg                  = module.referral-api.referral_api_sg
#   account_api_sg                   = module.account-api.account_api_sg_id
#   user_api_sg                      = module.user-api.user_api_sg
#   verification_api_sg              = module.verification-api.verification_api_sg
#   reseller_api_sg                  = module.reseller-api.reseller_api_sg
#   lambda_firebase_authorizer_sg_id = module.firebase-authorizer.lambda_firebase_authorizer_sg.id
#   bastion_sg                       = var.bastion_sg
#   crypto_api_sg_id                 = module.crypto-api.crypto_api_sg_id
#   crypto_api_module                = module.crypto-api
#   user_api_module                  = module.user-api
#   account_api_module               = module.account-api
#   reseller_api_module              = module.reseller-api
#   firebase_authorizer_module       = module.firebase-authorizer
#   referral_api_ecs_svc_sg          = module.referral-api.referral_api_ecs_svc_sg
# }

# module "config-api" {
#   source           = "./config-api"
#   default_listener = aws_lb_listener.look-card.arn
#   cluster          = aws_ecs_cluster.core_application.arn
#   network = {
#     vpc            = var.network.vpc
#     private_subnet = var.network.private_subnet
#     public_subnet  = var.network.public_subnet
#   }
#   image = {
#     url = aws_ecr_repository.look-card["config-api"].repository_url
#     tag = var.image_tag.config-api
#   }
#   lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
#   acm                     = var.acm
#   secret_manager          = var.secret_manager
#   env_tag                 = var.env_tag
#   sg_alb_id               = aws_security_group.api_alb_sg.id
#   bastion_sg              = var.bastion_sg
#   crypto_api_module       = module.crypto-api
#   account_api_module      = module.account-api
#   reseller_api_module     = module.reseller-api
# }

# module "data-api" {
#   source           = "./data-api"
#   default_listener = aws_lb_listener.look-card.arn
#   cluster          = aws_ecs_cluster.core_application.arn
#   network = {
#     vpc            = var.network.vpc
#     private_subnet = var.network.private_subnet
#     public_subnet  = var.network.public_subnet
#   }
#   image = {
#     url = aws_ecr_repository.look-card["data-api"].repository_url
#     tag = var.image_tag.data-api
#   }
#   lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
#   env_tag                 = var.env_tag
#   secret_manager          = var.secret_manager
#   kms                     = var.kms
#   # s3_data_bucket_name     = var.s3_data_bucket_name
#   sg_alb_id                   = aws_security_group.api_alb_sg.id
#   user_api_ecs_svc_sg         = module.user-api.user_api_ecs_svc_sg
#   verification_api_ecs_svc_sg = module.verification-api.verification_api_ecs_svc_sg
#   bastion_sg                  = var.bastion_sg
#   account_api_module          = module.account-api
# }

# module "xray-daemon" {
#   source  = "./xray-daemon"
#   cluster = aws_ecs_cluster.core_application.arn
#   network = {
#     vpc            = var.network.vpc
#     private_subnet = var.network.private_subnet
#     public_subnet  = var.network.public_subnet
#   }
#   lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
#   network_config          = var.network_config
# }

# module "referral-api" {
#   source = "./referral-api"
#   vpc_id = var.network.vpc
#   image = {
#     url = aws_ecr_repository.look-card["referral-api"].repository_url
#     tag = var.image_tag.referral-api
#   }
#   network = {
#     vpc            = var.network.vpc
#     private_subnet = var.network.private_subnet
#     public_subnet  = var.network.public_subnet
#   }
#   lookcardlocal_namespace               = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
#   cluster                               = aws_ecs_cluster.core_application.arn
#   secret_manager                        = var.secret_manager
#   sg_alb_id                             = aws_security_group.api_alb_sg.id
#   env_tag                               = var.env_tag
#   redis_host                            = var.redis_host
#   rds_aurora_postgresql_writer_endpoint = var.rds_aurora_postgresql_writer_endpoint
#   rds_aurora_postgresql_reader_endpoint = var.rds_aurora_postgresql_reader_endpoint
#   bastion_sg                            = var.bastion_sg
#   reseller_api_module                   = module.reseller-api
#   private_alb_sg                        = aws_security_group.private_alb_sg
#   # rds_proxy_host                        = var.rds_proxy_host
#   # rds_proxy_read_host                   = var.rds_proxy_read_host
#   # _auth_api_sg = module.authentication._auth_api_sg
# }

# module "reseller-api" {
#   source = "./reseller-api"
#   vpc_id = var.network.vpc
#   image = {
#     url = aws_ecr_repository.look-card["reseller-api"].repository_url
#     tag = var.image_tag.reseller-api
#   }
#   network = {
#     vpc            = var.network.vpc
#     private_subnet = var.network.private_subnet
#     public_subnet  = var.network.public_subnet
#   }
#   lookcardlocal_namespace               = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
#   cluster                               = aws_ecs_cluster.composite_application.arn
#   secret_manager                        = var.secret_manager
#   sg_alb_id                             = aws_security_group.api_alb_sg.id
#   env_tag                               = var.env_tag
#   redis_host                            = var.redis_host
#   rds_aurora_postgresql_writer_endpoint = var.rds_aurora_postgresql_writer_endpoint
#   rds_aurora_postgresql_reader_endpoint = var.rds_aurora_postgresql_reader_endpoint
#   bastion_sg                            = var.bastion_sg
#   default_listener                      = aws_lb_listener.look-card.arn
#   private_alb_sg                        = aws_security_group.private_alb_sg
# }

# # # ********************  Lambda functions  ***********************

# module "firebase-authorizer" {
#   source = "./firebase-authorizer"
#   network = {
#     vpc            = var.network.vpc
#     private_subnet = var.network.private_subnet
#     public_subnet  = var.network.public_subnet
#   }
#   image = {
#     url = aws_ecr_repository.look-card["apigw-authorizer"].repository_url
#     tag = var.image_tag.apigw-authorizer
#   }
#   env_tag = var.env_tag
# }

# module "sumsub-webhook" {
#   source = "./sumsub-webhook"
#   network = {
#     vpc            = var.network.vpc
#     private_subnet = var.network.private_subnet
#     public_subnet  = var.network.public_subnet
#   }
#   image = {
#     url = aws_ecr_repository.look-card["sumsub-webhook"].repository_url
#     tag = var.image_tag.sumsub-webhook
#   }
#   env_tag = var.env_tag
# }

# module "crypto-processor" {
#   source = "./crypto-processor"
#   network = {
#     vpc            = var.network.vpc
#     private_subnet = var.network.private_subnet
#   }

#   image = {
#     url = aws_ecr_repository.look-card["crypto-processor"].repository_url
#     tag = var.image_tag.crypto-processor
#   }

#   allow_to_security_group_ids = {
#     # sweep      = [module.account-api.account_api_ecs_svc_sg.id, module.config-api.config_api_ecs_svc_sg.id, module.profile-api.profile_api_sg.id]
#     sweep = []
#     withdrawal = []
#   }
# }

# module "cryptocurrency-withdrawal-processor" {
#   source = "./cryptocurrency-withdrawal-processor"
#   sqs    = module.sqs
#   network = {
#     vpc            = var.network.vpc
#     private_subnet = var.network.private_subnet
#     public_subnet  = var.network.public_subnet
#   }
#   image = {
#     url = aws_ecr_repository.look-card["cryptocurrency-withdrawal-processor"].repository_url
#     tag = var.image_tag.cryptocurrency-withdrawal-processor
#   }
#   secret_manager = var.secret_manager
# }

# module "cryptocurrency-sweep-processor" {
#   source = "./cryptocurrency-sweep-processor"
#   network = {
#     vpc            = var.network.vpc
#     private_subnet = var.network.private_subnet
#     public_subnet  = var.network.public_subnet
#   }
#   image = {
#     url = aws_ecr_repository.look-card["cryptocurrency-sweep-processor"].repository_url
#     tag = var.image_tag.cryptocurrency-sweep-processor
#   }
#   sqs            = module.sqs
#   secret_manager = var.secret_manager
# }

# module "notification-dispatcher" {
#   source = "./notification-dispatcher"
#   network = {
#     vpc            = var.network.vpc
#     private_subnet = var.network.private_subnet
#     public_subnet  = var.network.public_subnet
#   }
#   image = {
#     url = aws_ecr_repository.look-card["notification-dispatcher"].repository_url
#     tag = var.image_tag.notification-dispatcher
#   }
#   sqs            = module.sqs
#   secret_manager = var.secret_manager
# }

# module "edns-api" {
#   source = "./edns-api"
#   vpc_id = var.network.vpc
#   image = {
#     url = aws_ecr_repository.look-card["edns-api"].repository_url
#     tag = var.image_tag.edns-api
#   }
#   network = {
#     vpc            = var.network.vpc
#     private_subnet = var.network.private_subnet
#     public_subnet  = var.network.public_subnet
#   }
#   lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
#   cluster                 = aws_ecs_cluster.core_application.arn
#   secret_manager          = var.secret_manager
#   sg_alb_id               = aws_security_group.api_alb_sg.id
#   env_tag                 = var.env_tag
#   crypto_api_module       = module.crypto-api
#   reseller_api_module     = module.reseller-api
# }


# # ********************  v2 Portal  ***********************

# module "reseller-portal" {
#   source                   = "./reseller-portal"
#   domain                   = var.domain
#   storage                  = var.storage
#   security                 = var.security
#   reseller_portal_hostname = var.reseller_portal_hostname
#   aws_provider             = var.aws_provider
#   s3_bucket                = var.s3_bucket
# }
