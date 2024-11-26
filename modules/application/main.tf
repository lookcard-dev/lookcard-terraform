# # ********************  v2  ***********************

module "crypto-api" {
  source           = "./crypto-api"
  default_listener = aws_lb_listener.look-card.arn
  cluster          = aws_ecs_cluster.core_application.arn
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  image = {
    url = aws_ecr_repository.look-card["crypto-api"].repository_url
    tag = var.image_tag.crypto-api
  }
  secret_manager                        = var.secret_manager
  lookcardlocal_namespace               = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
  kms                                   = var.kms
  account_api_sg_id                     = module.account-api.account_api_sg_id
  sg_alb_id                             = aws_security_group.api_alb_sg.id
  lambda                                = var.lambda
  transaction_listener_sg_id            = module.crypto-listener.transaction_listener_sg_id
  env_tag                               = var.env_tag
  redis_host                            = var.redis_host
  rds_aurora_postgresql_writer_endpoint = var.rds_aurora_postgresql_writer_endpoint
  rds_aurora_postgresql_reader_endpoint = var.rds_aurora_postgresql_reader_endpoint
  # rds_proxy_host                        = var.rds_proxy_host
  # rds_proxy_read_host                   = var.rds_proxy_read_host
  reseller_api_sg = module.reseller-api.reseller_api_sg
  bastion_sg      = var.bastion_sg
  lambda_cryptocurrency_sweeper        = module.cryptocurrency-sweeper
  lambda_cryptocurrency_withdrawal     = module.cryptocurrency-withdrawal-processor
}

module "crypto-listener" {
  source = "./crypto-listener"
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  image = {
    url = aws_ecr_repository.look-card["crypto-listener"].repository_url
    tag = var.image_tag.transaction_listener
  }
  vpc_id                                   = var.network.vpc
  cluster                                  = aws_ecs_cluster.listener.arn
  dynamodb_crypto_transaction_listener_arn = var.dynamodb_crypto_transaction_listener_arn
  secret_manager                           = var.secret_manager
  sqs                                      = module.sqs
  capacity_provider_ec2_arm64_on_demand    = aws_ecs_capacity_provider.ec2_arm64_on_demand.name
  capacity_provider_ec2_amd64_on_demand    = aws_ecs_capacity_provider.ec2_amd64_on_demand.name
  rds_aurora_postgresql_writer_endpoint    = var.rds_aurora_postgresql_writer_endpoint
  rds_aurora_postgresql_reader_endpoint    = var.rds_aurora_postgresql_reader_endpoint
  env_tag                                  = var.env_tag
  # rds_proxy_host                           = var.rds_proxy_host
  # rds_proxy_read_host                      = var.rds_proxy_read_host
  bastion_sg = var.bastion_sg
}

module "account-api" {
  source           = "./account-api"
  default_listener = aws_lb_listener.look-card.arn
  vpc_id           = var.network.vpc
  image = {
    url = aws_ecr_repository.look-card["account-api"].repository_url
    tag = var.image_tag.account-api
  }
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  lookcardlocal_namespace               = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
  cluster                               = aws_ecs_cluster.core_application.arn
  sg_alb_id                             = aws_security_group.api_alb_sg.id
  lambda                                = var.lambda
  secret_manager                        = var.secret_manager
  sqs                                   = module.sqs
  acm                                   = var.acm
  env_tag                               = var.env_tag
  redis_host                            = var.redis_host
  rds_aurora_postgresql_writer_endpoint = var.rds_aurora_postgresql_writer_endpoint
  rds_aurora_postgresql_reader_endpoint = var.rds_aurora_postgresql_reader_endpoint
  # rds_proxy_host                        = var.rds_proxy_host
  # rds_proxy_read_host                   = var.rds_proxy_read_host
  reseller_api_sg = module.reseller-api.reseller_api_sg
  bastion_sg      = var.bastion_sg
  lambda_cryptocurrency_sweeper = module.cryptocurrency-sweeper
  lambda_cryptocurrency_withdrawal = module.cryptocurrency-withdrawal-processor
}

module "user-api" {
  source = "./user-api"
  vpc_id = var.network.vpc
  image = {
    url = aws_ecr_repository.look-card["user-api"].repository_url
    tag = var.image_tag.user-api
  }
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  lookcardlocal_namespace               = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
  cluster                               = aws_ecs_cluster.core_application.arn
  secret_manager                        = var.secret_manager
  sg_alb_id                             = aws_security_group.api_alb_sg.id
  env_tag                               = var.env_tag
  redis_host                            = var.redis_host
  rds_aurora_postgresql_writer_endpoint = var.rds_aurora_postgresql_writer_endpoint
  rds_aurora_postgresql_reader_endpoint = var.rds_aurora_postgresql_reader_endpoint
  lambda_firebase_authorizer_sg_id      = module.firebase-authorizer.lambda_firebase_authorizer_sg.id
  # rds_proxy_host                        = var.rds_proxy_host
  # rds_proxy_read_host                   = var.rds_proxy_read_host
  bastion_sg      = var.bastion_sg
  lambda          = var.lambda
  reseller_api_sg = module.reseller-api.reseller_api_sg
  lambda_cryptocurrency_sweeper = module.cryptocurrency-sweeper
  lambda_cryptocurrency_withdrawal = module.cryptocurrency-withdrawal-processor
}

module "reap-proxy" {
  source = "./reap-proxy"
  vpc_id = var.network.vpc
  image = {
    url = aws_ecr_repository.look-card["reap-proxy"].repository_url
    tag = var.image_tag.reap-proxy
  }
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  lookcardlocal_namespace  = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
  cluster                  = aws_ecs_cluster.core_application.arn
  secret_manager           = var.secret_manager
  sg_alb_id                = aws_security_group.api_alb_sg.id
  env_tag                  = var.env_tag
  lookcard_log_bucket_name = var.lookcard_log_bucket_name
  bastion_sg               = var.bastion_sg
}

module "verification-api" {
  source = "./verification-api"
  vpc_id = var.network.vpc
  image = {
    url = aws_ecr_repository.look-card["verification-api"].repository_url
    tag = var.image_tag.verification-api
  }
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  lookcardlocal_namespace               = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
  cluster                               = aws_ecs_cluster.core_application.arn
  secret_manager                        = var.secret_manager
  sg_alb_id                             = aws_security_group.api_alb_sg.id
  env_tag                               = var.env_tag
  redis_host                            = var.redis_host
  rds_aurora_postgresql_writer_endpoint = var.rds_aurora_postgresql_writer_endpoint
  rds_aurora_postgresql_reader_endpoint = var.rds_aurora_postgresql_reader_endpoint
  bastion_sg                            = var.bastion_sg
}

module "authentication-api" {
  source = "./authentication-api"
  vpc_id = var.network.vpc
  image = {
    url = aws_ecr_repository.look-card["authentication-api"].repository_url
    tag = var.image_tag.authentication-api
  }
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  lookcardlocal_namespace          = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
  cluster                          = aws_ecs_cluster.core_application.arn
  secret_manager                   = var.secret_manager
  sg_alb_id                        = aws_security_group.api_alb_sg.id
  env_tag                          = var.env_tag
  lambda_firebase_authorizer_sg_id = module.firebase-authorizer.lambda_firebase_authorizer_sg.id
  bastion_sg                       = var.bastion_sg
}

module "notification-api" {
  source           = "./notification-api"
  iam_role         = aws_iam_role.lookcard_ecs_task_role.arn
  default_listener = aws_lb_listener.look-card.arn
  cluster          = aws_ecs_cluster.core_application.arn
  image = {
    url = aws_ecr_repository.look-card["notification-v2-api"].repository_url
    tag = var.image_tag.notification_v2
  }
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  secret_manager = var.secret_manager
  env_tag        = var.env_tag
  sg_alb_id      = aws_security_group.api_alb_sg.id
  bastion_sg     = var.bastion_sg
}


module "profile-api" {
  source           = "./profile-api"
  default_listener = aws_lb_listener.look-card.arn
  cluster          = aws_ecs_cluster.core_application.arn
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  image = {
    url = aws_ecr_repository.look-card["profile-api"].repository_url
    tag = var.image_tag.profile-api
  }
  lookcardlocal_namespace          = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
  dynamodb_profile_data_table_name = var.dynamodb_profile_data_table_name
  secret_manager                   = var.secret_manager
  env_tag                          = var.env_tag
  sg_alb_id                        = aws_security_group.api_alb_sg.id
  referral_api_sg                  = module.referral-api.referral_api_sg
  account_api_sg                   = module.account-api.account_api_sg_id
  user_api_sg                      = module.user-api.user_api_sg
  #_auth_api_sg                     = module.authentication._auth_api_sg
  verification_api_sg              = module.verification-api.verification_api_sg
  profile_api_ddb_table            = var.profile_api_ddb_table
  reseller_api_sg                  = module.reseller-api.reseller_api_sg
  lambda_firebase_authorizer_sg_id = module.firebase-authorizer.lambda_firebase_authorizer_sg.id
  bastion_sg                       = var.bastion_sg
  crypto_api_sg_id                 = module.crypto-api.crypto_api_sg_id
  lambda_cryptocurrency_sweeper = module.cryptocurrency-sweeper
}

module "config-api" {
  source           = "./config-api"
  default_listener = aws_lb_listener.look-card.arn
  cluster          = aws_ecs_cluster.core_application.arn
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  image = {
    url = aws_ecr_repository.look-card["config-api"].repository_url
    tag = var.image_tag.config-api
  }
  lookcardlocal_namespace              = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
  dynamodb_config_api_config_data_name = var.dynamodb_config_api_config_data_name
  dynamodb_config_api_config_data_arn  = var.dynamodb_config_api_config_data_arn
  acm                                  = var.acm
  secret_manager                       = var.secret_manager
  env_tag                              = var.env_tag
  sg_alb_id                            = aws_security_group.api_alb_sg.id
  bastion_sg                           = var.bastion_sg
}

module "data-api" {
  source           = "./data-api"
  default_listener = aws_lb_listener.look-card.arn
  cluster          = aws_ecs_cluster.core_application.arn
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  image = {
    url = aws_ecr_repository.look-card["data-api"].repository_url
    tag = var.image_tag.data-api
  }
  lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
  env_tag                 = var.env_tag
  secret_manager          = var.secret_manager
  kms                     = var.kms
  s3_data_bucket_name     = var.s3_data_bucket_name
  dynamodb_data_tb_name   = var.dynamodb_data_tb_name
  sg_alb_id               = aws_security_group.api_alb_sg.id
  crypto_api_sg_id        = module.crypto-api.crypto_api_sg_id
  bastion_sg              = var.bastion_sg
}

module "xray-daemon" {
  source  = "./xray-daemon"
  cluster = aws_ecs_cluster.core_application.arn
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
}

module "referral-api" {
  source = "./referral-api"
  vpc_id = var.network.vpc
  image = {
    url = aws_ecr_repository.look-card["referral-api"].repository_url
    tag = var.image_tag.referral-api
  }
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  lookcardlocal_namespace               = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
  cluster                               = aws_ecs_cluster.core_application.arn
  secret_manager                        = var.secret_manager
  sg_alb_id                             = aws_security_group.api_alb_sg.id
  env_tag                               = var.env_tag
  redis_host                            = var.redis_host
  rds_aurora_postgresql_writer_endpoint = var.rds_aurora_postgresql_writer_endpoint
  rds_aurora_postgresql_reader_endpoint = var.rds_aurora_postgresql_reader_endpoint
  bastion_sg                            = var.bastion_sg
  # rds_proxy_host                        = var.rds_proxy_host
  # rds_proxy_read_host                   = var.rds_proxy_read_host
  # _auth_api_sg = module.authentication._auth_api_sg
}

module "reseller-api" {
  source = "./reseller-api"
  vpc_id = var.network.vpc
  image = {
    url = aws_ecr_repository.look-card["reseller-api"].repository_url
    tag = var.image_tag.reseller-api
  }
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  lookcardlocal_namespace               = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
  cluster                               = aws_ecs_cluster.composite_application.arn
  secret_manager                        = var.secret_manager
  sg_alb_id                             = aws_security_group.api_alb_sg.id
  env_tag                               = var.env_tag
  redis_host                            = var.redis_host
  rds_aurora_postgresql_writer_endpoint = var.rds_aurora_postgresql_writer_endpoint
  rds_aurora_postgresql_reader_endpoint = var.rds_aurora_postgresql_reader_endpoint
  bastion_sg                            = var.bastion_sg
  # rds_proxy_host                        = var.rds_proxy_host
  # rds_proxy_read_host                   = var.rds_proxy_read_host
  # _auth_api_sg     = module.authentication._auth_api_sg
  default_listener = aws_lb_listener.look-card.arn
}

# # ********************  Lambda functions  ***********************

module "firebase-authorizer" {
  source = "./firebase-authorizer"
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  image = {
    url = aws_ecr_repository.look-card["apigw-authorizer"].repository_url
    tag = var.image_tag.apigw-authorizer
  }
  env_tag = var.env_tag
}

module "sumsub-webhook" {
  source = "./sumsub-webhook"
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  image = {
    url = aws_ecr_repository.look-card["sumsub-webhook"].repository_url
    tag = var.image_tag.sumsub-webhook
  }
  env_tag = var.env_tag
}

module "cryptocurrency-withdrawal-processor" {
  source = "./cryptocurrency-withdrawal-processor"
  sqs    = module.sqs
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  image = {
    url = aws_ecr_repository.look-card["cryptocurrency-withdrawal-processor"].repository_url
    tag = var.image_tag.cryptocurrency-withdrawal-processor
  }
  secret_manager = var.secret_manager
}

module "cryptocurrency-sweeper" {
  source = "./cryptocurrency-sweeper"
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  image = {
    url = aws_ecr_repository.look-card["cryptocurrency-withdrawal-processor"].repository_url
    tag = var.image_tag.cryptocurrency-withdrawal-processor
  }
  sqs            = module.sqs
  secret_manager = var.secret_manager
}

module "notification-dispatcher" {
  source = "./notification-dispatcher"
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  image = {
    url = aws_ecr_repository.look-card["notification-dispatcher"].repository_url
    tag = var.image_tag.notification-dispatcher
  }
  sqs            = module.sqs
  secret_manager = var.secret_manager
}

# # ********************  v2 Portal  ***********************

module "reseller-portal" {
  source = "./reseller-portal"
  domain = var.domain
  storage = var.storage
  security = var.security
  reseller_portal_hostname = var.reseller_portal_hostname
  aws_provider = var.aws_provider
  s3_bucket = var.s3_bucket
}

# # ********************  v2 SQS  ***********************
module "sqs" {
  source = "./sqs"
}


# # ********************  v1  ***********************

# module "authentication" {
#   source              = "./_authentication-api"
#   vpc_id              = var.network.vpc
#   aws_lb_listener_arn = aws_lb_listener.look-card.arn
#   cluster             = aws_ecs_cluster.application.arn
#   sg_alb_id           = aws_security_group.api_alb_sg.id
#   network = {
#     vpc                     = var.network.vpc
#     private_subnet          = var.network.private_subnet
#     public_subnet           = var.network.public_subnet
#     public_subnet_cidr_list = var.network.public_subnet_cidr_list
#   }
#   image = {
#     url = aws_ecr_repository.look-card["authentication-api"].repository_url
#     tag = var.image_tag.authentication_api
#   }
#   secret_manager = var.secret_manager
#   iam_role       = aws_iam_role.lookcard_ecs_task_role.arn
#   sqs            = var.sqs
#   cluster_name   = aws_ecs_cluster.application.name
# }

# module "_transaction-api" {
#   source           = "./_transaction-api"
#   default_listener = aws_lb_listener.look-card.arn
#   network = {
#     vpc            = var.network.vpc
#     private_subnet = var.network.private_subnet
#     public_subnet  = var.network.public_subnet
#   }
#   image = {
#     url = aws_ecr_repository.look-card["transaction-api"].repository_url
#     tag = var.image_tag.transaction_api
#   }
#   vpc_id                  = var.network.vpc
#   iam_role                = aws_iam_role.lookcard_ecs_task_role.arn
#   sg_alb_id               = aws_security_group.api_alb_sg.id
#   cluster                 = aws_ecs_cluster.application.arn
#   lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
#   secret_manager          = var.secret_manager
#   account_api_sg_id       = module.account-api.account_api_sg_id
# }

# module "_user-api" {
#   source           = "./_user-api"
#   iam_role         = aws_iam_role.lookcard_ecs_task_role.arn
#   default_listener = aws_lb_listener.look-card.arn
#   cluster          = aws_ecs_cluster.application.arn
#   network = {
#     vpc            = var.network.vpc
#     private_subnet = var.network.private_subnet
#     public_subnet  = var.network.public_subnet
#   }
#   image = {
#     url = aws_ecr_repository.look-card["users-api"].repository_url
#     tag = var.image_tag._user-api
#   }
#   lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
#   secret_manager          = var.secret_manager
#   sg_alb_id               = aws_security_group.api_alb_sg.id
#   lambda                  = var.lambda
#   account_api_sg_id       = module.account-api.account_api_sg_id
# }

# module "_reporting-api" {
#   source           = "./_reporting-api"
#   iam_role         = aws_iam_role.lookcard_ecs_task_role.arn
#   default_listener = aws_lb_listener.look-card.arn
#   cluster          = aws_ecs_cluster.application.arn
#   network = {
#     vpc            = var.network.vpc
#     private_subnet = var.network.private_subnet
#     public_subnet  = var.network.public_subnet
#   }
#   image = {
#     url = aws_ecr_repository.look-card["reporting-api"].repository_url
#     tag = var.image_tag.reporting_api
#   }
#   secret_manager = var.secret_manager
#   sg_alb_id      = aws_security_group.api_alb_sg.id
# }

# module "_card-api" {
#   source           = "./_card-api"
#   iam_role         = aws_iam_role.lookcard_ecs_task_role.arn
#   default_listener = aws_lb_listener.look-card.arn
#   cluster          = aws_ecs_cluster.application.arn
#   network = {
#     vpc            = var.network.vpc
#     private_subnet = var.network.private_subnet
#     public_subnet  = var.network.public_subnet
#   }
#   image = {
#     url = aws_ecr_repository.look-card["card-api"].repository_url
#     tag = var.image_tag.card_api
#   }
#   secret_manager          = var.secret_manager
#   lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
# }

# module "_blockchain-api" {
#   source           = "./_blockchain-api"
#   iam_role         = aws_iam_role.lookcard_ecs_task_role.arn
#   default_listener = aws_lb_listener.look-card.arn
#   cluster          = aws_ecs_cluster.application.arn
#   secret_manager   = var.secret_manager
#   sg_alb_id        = aws_security_group.api_alb_sg.id
#   image = {
#     url = aws_ecr_repository.look-card["blockchain-api"].repository_url
#     tag = var.image_tag.blockchain_api
#   }
#   network = {
#     vpc            = var.network.vpc
#     private_subnet = var.network.private_subnet
#     public_subnet  = var.network.public_subnet
#   }
#   lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id

# }

# module "_utility-api" {
#   source           = "./_utility-api"
#   iam_role         = aws_iam_role.lookcard_ecs_task_role.arn
#   default_listener = aws_lb_listener.look-card.arn
#   cluster          = aws_ecs_cluster.application.arn
#   network = {
#     vpc            = var.network.vpc
#     private_subnet = var.network.private_subnet
#     public_subnet  = var.network.public_subnet
#   }
#   image = {
#     url = aws_ecr_repository.look-card["utility-api"].repository_url
#     tag = var.image_tag.utility_api
#   }
#   lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
#   secret_manager          = var.secret_manager
#   sg_alb_id               = aws_security_group.api_alb_sg.id
#   account_api_sg_id       = module.account-api.account_api_sg_id
# }

# module "_notification-api" {
#   source           = "./_notification-api"
#   iam_role         = aws_iam_role.lookcard_ecs_task_role.arn
#   default_listener = aws_lb_listener.look-card.arn
#   cluster          = aws_ecs_cluster.application.arn
#   sg_alb_id        = aws_security_group.api_alb_sg.id
#   image = {
#     url = aws_ecr_repository.look-card["notification-api"].repository_url
#     tag = var.image_tag.notification
#   }
#   network = {
#     vpc            = var.network.vpc
#     private_subnet = var.network.private_subnet
#     public_subnet  = var.network.public_subnet
#   }
#   secret_manager = var.secret_manager
#   env_tag        = var.env_tag
# }
