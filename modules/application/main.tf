module "hello-world" {
  source = "./helloworld"
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  ecs_cluster_id      = aws_ecs_cluster.look_card.id
  private_subnet_list = var.network.private_subnet
  alb_arn             = aws_alb.look-card.arn
}

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
  secret_manager = var.secret_manager
  sqs_withdrawal       = var.sqs_withdrawal
  iam_role             = aws_iam_role.lookcard_ecs_task_role.arn
}

module "crypto_api" {
  source           = "./crypto_api"
  default_listener = aws_lb_listener.look-card.arn
  cluster          = aws_ecs_cluster.look_card.arn
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  secret_manager = var.secret_manager
  crypto_api_encryption_kms_arn = aws_kms_key.crypto_api_encryption.arn
  crypto_api_generator_kms_arn  = aws_kms_key.crypto_api_generator.arn
  lookcardlocal_namespace_id    = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
}

module "transaction_api" {
  source           = "./transaction_api"
  default_listener = aws_lb_listener.look-card.arn
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  vpc_id                     = var.network.vpc
  iam_role                   = aws_iam_role.lookcard_ecs_task_role.arn
  sg_alb_id                  = aws_security_group.api_alb_sg.id
  cluster                    = aws_ecs_cluster.look_card.arn
  lookcardlocal_namespace_id = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
  secret_manager             = var.secret_manager
}


module "transaction_listener" {
  source = "./transaction_listener"
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  vpc_id                                   = var.network.vpc
  cluster                                  = aws_ecs_cluster.look_card.arn
  aggregator_tron_sqs_url                  = var.aggregator_tron_sqs_url
  dynamodb_crypto_transaction_listener_arn = var.dynamodb_crypto_transaction_listener_arn
  aggregator_tron_sqs_arn                  = var.aggregator_tron_sqs_arn
  secret_manager             = var.secret_manager
}

module "account_api" {
  source           = "./account_api"
  default_listener = aws_lb_listener.look-card.arn
  vpc_id           = var.network.vpc
  # secret_arns      = var.secret_arns
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  lookcard_notification_sqs_url  = var.lookcard_notification_sqs_url
  crypto_fund_withdrawal_sqs_url = var.crypto_fund_withdrawal_sqs_url
  lookcardlocal_namespace_id     = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
  cluster                        = aws_ecs_cluster.look_card.arn
  secret_manager                 = var.secret_manager
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
  secret_manager                 = var.secret_manager
  lookcardlocal_namespace_id = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
}

module "blockchain" {
  source           = "./blockchain_service"
  iam_role         = aws_iam_role.lookcard_ecs_task_role.arn
  default_listener = aws_lb_listener.look-card.arn
  cluster          = aws_ecs_cluster.look_card.arn
  secret_manager   = var.secret_manager
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  lookcardlocal_namespace_id = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
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
  lookcardlocal_namespace_id = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
  secret_manager   = var.secret_manager
}


module "notification" {
  source           = "./notification_service"
  iam_role         = aws_iam_role.lookcard_ecs_task_role.arn
  default_listener = aws_lb_listener.look-card.arn
  cluster          = aws_ecs_cluster.look_card.arn
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
  }
  secret_manager   = var.secret_manager
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
  lookcardlocal_namespace_id = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
  secret_manager   = var.secret_manager
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
  secret_manager   = var.secret_manager
}
