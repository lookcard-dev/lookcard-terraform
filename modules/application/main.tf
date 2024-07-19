# module "hello-world" {
#   source = "./helloworld"
#   network = {
#     vpc            = var.network.vpc
#     private_subnet = var.network.private_subnet
#     public_subnet  = var.network.public_subnet
#   }
#   ecs_cluster_id      = aws_ecs_cluster.look_card.id
#   private_subnet_list = var.network.private_subnet
#   alb_arn             = aws_alb.look-card.arn
# }

module "authentication" {
  source              = "./authentication"
  vpc_id              = var.network.vpc
  aws_lb_listener_arn = aws_lb_listener.look-card.arn
  cluster             = aws_ecs_cluster.look_card.arn
  sg_alb_id           = aws_security_group.api_alb_sg.id
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  image = {
    url = aws_ecr_repository.look-card["authentication-api"].repository_url
    tag = var.image_tag.authentication_api
  }
  secret_manager = var.secret_manager
  iam_role       = aws_iam_role.lookcard_ecs_task_role.arn
  sqs            = var.sqs
  cluster_name   = aws_ecs_cluster.look_card.name
}

module "crypto_api" {
  source           = "./crypto-api"
  default_listener = aws_lb_listener.look-card.arn
  cluster          = aws_ecs_cluster.look_card.arn
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  image = {
    url = aws_ecr_repository.look-card["crypto-api"].repository_url
    tag = var.image_tag.crypto_api
  }
  secret_manager                = var.secret_manager
  crypto_api_encryption_kms_arn = aws_kms_key.crypto_api_encryption.arn
  crypto_api_generator_kms_arn  = aws_kms_key.crypto_api_generator.arn
  api_lookcardlocal_namespace   = aws_service_discovery_private_dns_namespace.api_lookcardlocal_namespace.id
}

module "transaction_api" {
  source           = "./transaction_api"
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
  vpc_id                      = var.network.vpc
  iam_role                    = aws_iam_role.lookcard_ecs_task_role.arn
  sg_alb_id                   = aws_security_group.api_alb_sg.id
  cluster                     = aws_ecs_cluster.look_card.arn
  api_lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.api_lookcardlocal_namespace.id
  secret_manager              = var.secret_manager
}


module "transaction_listener" {
  source = "./transaction_listener"
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  image = {
    url = aws_ecr_repository.look-card["transaction-listener"].repository_url
    tag = var.image_tag.transaction_listener
  }
  vpc_id  = var.network.vpc
  cluster = aws_ecs_cluster.look_card.arn
  # aggregator_tron_sqs_url                  = var.aggregator_tron_sqs_url
  dynamodb_crypto_transaction_listener_arn = var.dynamodb_crypto_transaction_listener_arn
  # aggregator_tron_sqs_arn                  = var.aggregator_tron_sqs_arn
  secret_manager      = var.secret_manager
  trongrid_secret_arn = var.trongrid_secret_arn
  sqs                 = var.sqs
}

module "account_api" {
  source           = "./account_api"
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
  api_lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.api_lookcardlocal_namespace.id
  cluster                     = aws_ecs_cluster.look_card.arn
  secret_manager              = var.secret_manager
  sqs                         = var.sqs
}


module "card" {
  source           = "./card_service"
  iam_role         = aws_iam_role.lookcard_ecs_task_role.arn
  default_listener = aws_lb_listener.look-card.arn
  cluster          = aws_ecs_cluster.look_card.arn
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  image = {
    url = aws_ecr_repository.look-card["card-api"].repository_url
    tag = var.image_tag.card_api
  }
  secret_manager              = var.secret_manager
  api_lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.api_lookcardlocal_namespace.id
}

module "blockchain" {
  source           = "./blockchain_service"
  iam_role         = aws_iam_role.lookcard_ecs_task_role.arn
  default_listener = aws_lb_listener.look-card.arn
  cluster          = aws_ecs_cluster.look_card.arn
  secret_manager   = var.secret_manager
  image = {
    url = aws_ecr_repository.look-card["blockchain-api"].repository_url
    tag = var.image_tag.blockchain_api
  }
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  api_lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.api_lookcardlocal_namespace.id
}

module "utility" {
  source           = "./utility_service"
  iam_role         = aws_iam_role.lookcard_ecs_task_role.arn
  default_listener = aws_lb_listener.look-card.arn
  cluster          = aws_ecs_cluster.look_card.arn
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  image = {
    url = aws_ecr_repository.look-card["utility-api"].repository_url
    tag = var.image_tag.utility_api
  }
  api_lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.api_lookcardlocal_namespace.id
  secret_manager              = var.secret_manager
}


module "notification" {
  source           = "./notification_service"
  iam_role         = aws_iam_role.lookcard_ecs_task_role.arn
  default_listener = aws_lb_listener.look-card.arn
  cluster          = aws_ecs_cluster.look_card.arn
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
}

module "user" {
  source           = "./user_service"
  iam_role         = aws_iam_role.lookcard_ecs_task_role.arn
  default_listener = aws_lb_listener.look-card.arn
  cluster          = aws_ecs_cluster.look_card.arn
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  image = {
    url = aws_ecr_repository.look-card["users-api"].repository_url
    tag = var.image_tag.users_api
  }
  api_lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.api_lookcardlocal_namespace.id
  secret_manager              = var.secret_manager
}


module "reporting" {
  source           = "./reporting_service"
  iam_role         = aws_iam_role.lookcard_ecs_task_role.arn
  default_listener = aws_lb_listener.look-card.arn
  cluster          = aws_ecs_cluster.look_card.arn
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
}

module "profile_api" {
  source           = "./profile-api"
  default_listener = aws_lb_listener.look-card.arn
  cluster          = aws_ecs_cluster.look_card.arn
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  image = {
    url = aws_ecr_repository.look-card["profile-api"].repository_url
    tag = var.image_tag.profile_api
  }
  api_lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.api_lookcardlocal_namespace.id
  # secret_manager = var.secret_manager
}
module "config_api" {
  source           = "./config-api"
  default_listener = aws_lb_listener.look-card.arn
  cluster          = aws_ecs_cluster.look_card.arn
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  image = {
    url = aws_ecr_repository.look-card["config-api"].repository_url
    tag = var.image_tag.config_api
  }
  api_lookcardlocal_namespace          = aws_service_discovery_private_dns_namespace.api_lookcardlocal_namespace.id
  dynamodb_config_api_config_data_name = var.dynamodb_config_api_config_data_name
  dynamodb_config_api_config_data_arn  = var.dynamodb_config_api_config_data_arn
  lookcard_api_domain                  = var.lookcard_api_domain
}

module "data_api" {
  source           = "./data-api"
  default_listener = aws_lb_listener.look-card.arn
  cluster          = aws_ecs_cluster.look_card.arn
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  image = {
    url = aws_ecr_repository.look-card["data-api"].repository_url
    tag = var.image_tag.data_api
  }
  api_lookcardlocal_namespace     = aws_service_discovery_private_dns_namespace.api_lookcardlocal_namespace.id
  kms_encryption_key_id_alpha_arn = aws_kms_key.data_encryption_key_alpha.arn
  kms_generator_key_id_arn        = aws_kms_key.data_generator_key.arn
}

module "xray_daemon" {
  source  = "./xray-daemon"
  cluster = aws_ecs_cluster.look_card.arn
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  lookcardlocal_namespace = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
}
