# # ********************  v2  ***********************

module "crypto-api" {
  source           = "./crypto-api"
  default_listener = aws_lb_listener.look-card.arn
  cluster          = aws_ecs_cluster.application.arn
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  image = {
    url = aws_ecr_repository.look-card["crypto-api"].repository_url
    tag = var.image_tag.crypto_api
  }
  secret_manager             = var.secret_manager
  lookcardlocal_namespace    = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
  kms                        = var.kms
  account_api_sg_id          = module.account-api.account_api_sg_id
  sg_alb_id                  = aws_security_group.api_alb_sg.id
  lambda                     = var.lambda
  transaction_listener_sg_id = module.transaction-listener.transaction_listener_sg_id
  # kms_data_generator_key_arn        = var.kms_data_generator_key_arn
  # kms_data_encryption_key_alpha_arn = var.kms_data_encryption_key_alpha_arn
}

module "transaction-listener" {
  source = "./transaction-listener"
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
  trongrid_secret_arn                      = var.trongrid_secret_arn
  database_secret_arn                      = var.database_secret_arn
  get_block_secret_arn                     = var.get_block_secret_arn
  sqs                                      = var.sqs
  capacity_provider_ec2_arm64_on_demand    = aws_ecs_capacity_provider.ec2_arm64_on_demand.name
  capacity_provider_ec2_amd64_on_demand    = aws_ecs_capacity_provider.ec2_amd64_on_demand.name
  rds_aurora_postgresql_writer_endpoint    = var.rds_aurora_postgresql_writer_endpoint
  rds_aurora_postgresql_reader_endpoint    = var.rds_aurora_postgresql_reader_endpoint
  env_tag                                  = var.env_tag
}

module "account-api" {
  source           = "./account-api"
  default_listener = aws_lb_listener.look-card.arn
  vpc_id           = var.network.vpc
  image = {
    url = aws_ecr_repository.look-card["account-api"].repository_url
    tag = var.image_tag.account_api
  }
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
  cluster                 = aws_ecs_cluster.application.arn
  sg_alb_id               = aws_security_group.api_alb_sg.id
  lambda                  = var.lambda
  secret_manager          = var.secret_manager
  sqs                     = var.sqs
  acm                     = var.acm
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
  lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
  cluster                 = aws_ecs_cluster.application.arn
  secret_manager          = var.secret_manager
  sg_alb_id               = aws_security_group.api_alb_sg.id
  env_tag                 = var.env_tag
  redis_host              = var.redis_host
}

module "notification-api" {
  source           = "./notification-api"
  iam_role         = aws_iam_role.lookcard_ecs_task_role.arn
  default_listener = aws_lb_listener.look-card.arn
  cluster          = aws_ecs_cluster.application.arn
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
}


module "profile-api" {
  source           = "./profile-api"
  default_listener = aws_lb_listener.look-card.arn
  cluster          = aws_ecs_cluster.application.arn
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  image = {
    url = aws_ecr_repository.look-card["profile-api"].repository_url
    tag = var.image_tag.profile_api
  }
  lookcardlocal_namespace          = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
  dynamodb_profile_data_table_name = var.dynamodb_profile_data_table_name
  secret_manager                   = var.secret_manager
  env_tag                          = var.env_tag
  sg_alb_id                        = aws_security_group.api_alb_sg.id
}

module "config-api" {
  source           = "./config-api"
  default_listener = aws_lb_listener.look-card.arn
  cluster          = aws_ecs_cluster.application.arn
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  image = {
    url = aws_ecr_repository.look-card["config-api"].repository_url
    tag = var.image_tag.config_api
  }
  lookcardlocal_namespace              = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
  dynamodb_config_api_config_data_name = var.dynamodb_config_api_config_data_name
  dynamodb_config_api_config_data_arn  = var.dynamodb_config_api_config_data_arn
  acm                                  = var.acm
  secret_manager                       = var.secret_manager
  env_tag                              = var.env_tag
  sg_alb_id                            = aws_security_group.api_alb_sg.id
}

module "data-api" {
  source           = "./data-api"
  default_listener = aws_lb_listener.look-card.arn
  cluster          = aws_ecs_cluster.application.arn
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  image = {
    url = aws_ecr_repository.look-card["data-api"].repository_url
    tag = var.image_tag.data_api
  }
  lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
  env_tag                 = var.env_tag
  secret_manager          = var.secret_manager
  kms                     = var.kms
  s3_data_bucket_name     = var.s3_data_bucket_name
  dynamodb_data_tb_name   = var.dynamodb_data_tb_name
  sg_alb_id               = aws_security_group.api_alb_sg.id
}

module "xray-daemon" {
  source  = "./xray-daemon"
  cluster = aws_ecs_cluster.application.arn
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
}

# # ********************  v1  ***********************

module "authentication" {
  source              = "./_authentication-api"
  vpc_id              = var.network.vpc
  aws_lb_listener_arn = aws_lb_listener.look-card.arn
  cluster             = aws_ecs_cluster.application.arn
  sg_alb_id           = aws_security_group.api_alb_sg.id
  network = {
    vpc                     = var.network.vpc
    private_subnet          = var.network.private_subnet
    public_subnet           = var.network.public_subnet
    public_subnet_cidr_list = var.network.public_subnet_cidr_list
  }
  image = {
    url = aws_ecr_repository.look-card["authentication-api"].repository_url
    tag = var.image_tag.authentication_api
  }
  secret_manager = var.secret_manager
  iam_role       = aws_iam_role.lookcard_ecs_task_role.arn
  sqs            = var.sqs
  cluster_name   = aws_ecs_cluster.application.name
}

module "_transaction-api" {
  source           = "./_transaction-api"
  default_listener = aws_lb_listener.look-card.arn
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  image = {
    url = aws_ecr_repository.look-card["transaction-api"].repository_url
    tag = var.image_tag.transaction_api
  }
  vpc_id                  = var.network.vpc
  iam_role                = aws_iam_role.lookcard_ecs_task_role.arn
  sg_alb_id               = aws_security_group.api_alb_sg.id
  cluster                 = aws_ecs_cluster.application.arn
  lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
  secret_manager          = var.secret_manager
  account_api_sg_id       = module.account-api.account_api_sg_id
}

module "_user-api" {
  source           = "./_user-api"
  iam_role         = aws_iam_role.lookcard_ecs_task_role.arn
  default_listener = aws_lb_listener.look-card.arn
  cluster          = aws_ecs_cluster.application.arn
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  image = {
    url = aws_ecr_repository.look-card["users-api"].repository_url
    tag = var.image_tag.users_api
  }
  lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
  secret_manager          = var.secret_manager
  sg_alb_id               = aws_security_group.api_alb_sg.id
  lambda                  = var.lambda
  account_api_sg_id       = module.account-api.account_api_sg_id
}

module "_reporting-api" {
  source           = "./_reporting-api"
  iam_role         = aws_iam_role.lookcard_ecs_task_role.arn
  default_listener = aws_lb_listener.look-card.arn
  cluster          = aws_ecs_cluster.application.arn
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  image = {
    url = aws_ecr_repository.look-card["reporting-api"].repository_url
    tag = var.image_tag.reporting_api
  }
  secret_manager = var.secret_manager
  sg_alb_id      = aws_security_group.api_alb_sg.id
}

module "_card-api" {
  source           = "./_card-api"
  iam_role         = aws_iam_role.lookcard_ecs_task_role.arn
  default_listener = aws_lb_listener.look-card.arn
  cluster          = aws_ecs_cluster.application.arn
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  image = {
    url = aws_ecr_repository.look-card["card-api"].repository_url
    tag = var.image_tag.card_api
  }
  secret_manager          = var.secret_manager
  lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
}

module "_blockchain-api" {
  source           = "./_blockchain-api"
  iam_role         = aws_iam_role.lookcard_ecs_task_role.arn
  default_listener = aws_lb_listener.look-card.arn
  cluster          = aws_ecs_cluster.application.arn
  secret_manager   = var.secret_manager
  sg_alb_id        = aws_security_group.api_alb_sg.id
  image = {
    url = aws_ecr_repository.look-card["blockchain-api"].repository_url
    tag = var.image_tag.blockchain_api
  }
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id

}

module "_utility-api" {
  source           = "./_utility-api"
  iam_role         = aws_iam_role.lookcard_ecs_task_role.arn
  default_listener = aws_lb_listener.look-card.arn
  cluster          = aws_ecs_cluster.application.arn
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  image = {
    url = aws_ecr_repository.look-card["utility-api"].repository_url
    tag = var.image_tag.utility_api
  }
  lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
  secret_manager          = var.secret_manager
  sg_alb_id               = aws_security_group.api_alb_sg.id
  account_api_sg_id       = module.account-api.account_api_sg_id
}

module "_notification-api" {
  source           = "./_notification-api"
  iam_role         = aws_iam_role.lookcard_ecs_task_role.arn
  default_listener = aws_lb_listener.look-card.arn
  cluster          = aws_ecs_cluster.application.arn
  sg_alb_id        = aws_security_group.api_alb_sg.id
  image = {
    url = aws_ecr_repository.look-card["notification-api"].repository_url
    tag = var.image_tag.notification
  }
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  secret_manager = var.secret_manager
  env_tag        = var.env_tag
}
