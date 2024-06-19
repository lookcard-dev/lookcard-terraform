module "hello-world" {
  source              = "./helloworld"
  # vpc_id              = var.network.vpc
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
  # env                 = var.env
  aws_lb_listener_arn = aws_lb_listener.look-card.arn
  # aws_lb_target_group_lookcard_tg_arn = aws_lb_target_group.lookcard_tg.arn
  cluster             = aws_ecs_cluster.look_card.arn
  sg_alb_id           = aws_security_group.api_alb_sg.id
  network = {
    vpc               = var.network.vpc
    private_subnet    = var.network.private_subnet
    public_subnet     = var.network.public_subnet
  }
  sqs_withdrawal      = var.sqs_withdrawal
  iam_role            = aws_iam_role.lookcard_ecs_task_role.arn

  # ecs_cluster_id      = aws_ecs_cluster.look_card.id
  # private_subnet_list = var.network.private_subnet_ids
  # alb_arn             = aws_alb.look-card.arn
  # ssl                 = var.
}

module "crypto_api" {
  source              = "./crypto_api"
  default_listener    = aws_lb_listener.look-card.arn
  # vpc_id              = var.network.vpc
  # aws_lb_listener_arn = aws_lb_listener.look-card.arn
  # aws_lb_target_group_lookcard_tg_arn = aws_lb_target_group.lookcard_tg.arn
  cluster             = aws_ecs_cluster.look_card.arn
  # sg_alb_id           = aws_security_group.api_alb_sg.id
  network = {
    vpc               = var.network.vpc
    private_subnet    = var.network.private_subnet
    public_subnet     = var.network.public_subnet
  }
   crypto_api_secret_arn = var.crypto_api_secret_arn
firebase_secret_arn = var.firebase_secret_arn
db_secret_secret_arn = var.db_secret_secret_arn
  lookcardlocal_namespace_id = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
}

module "transaction_api" {
  source              = "./transaction_api"
  default_listener    = aws_lb_listener.look-card.arn
  network = {
    vpc               = var.network.vpc
    private_subnet    = var.network.private_subnet
    public_subnet     = var.network.public_subnet
  }
  vpc_id              = var.network.vpc
  iam_role            = aws_iam_role.lookcard_ecs_task_role.arn
  sg_alb_id           = aws_security_group.api_alb_sg.id
  cluster             = aws_ecs_cluster.look_card.arn
  lookcardlocal_namespace_id = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
}


module "transaction_listener" {
  source              = "./transaction_listener"
  # default_listener    = aws_lb_listener.look-card.arn
  network = {
    vpc               = var.network.vpc
    private_subnet    = var.network.private_subnet
    public_subnet     = var.network.public_subnet
  }
  vpc_id              = var.network.vpc
  # iam_role            = aws_iam_role.lookcard_ecs_task_role.arn
  # sg_alb_id           = aws_security_group.api_alb_sg.id
  cluster             = aws_ecs_cluster.look_card.arn
  # lookcardlocal_namespace_id = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
}

module "account_api" {
  source              = "./account_api"
  default_listener    = aws_lb_listener.look-card.arn
  vpc_id              = var.network.vpc
  secret_arns         = var.secret_arns
  network = {
    vpc               = var.network.vpc
    private_subnet    = var.network.private_subnet
    public_subnet     = var.network.public_subnet
  }
  lookcard_notification_sqs_url = var.lookcard_notification_sqs_url
  crypto_fund_withdrawal_sqs_url = var.crypto_fund_withdrawal_sqs_url
  lookcardlocal_namespace_id = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
  # vpc_id              = var.network.vpc
  # iam_role            = aws_iam_role.lookcard_ecs_task_role.arn
  # sg_alb_id           = aws_security_group.api_alb_sg.id
  cluster             = aws_ecs_cluster.look_card.arn
  crypto_api_secret_arn = var.crypto_api_secret_arn
firebase_secret_arn = var.firebase_secret_arn
elliptic_secret_arn = var.elliptic_secret_arn
db_secret_secret_arn = var.db_secret_secret_arn
}


module "card" {
  source              = "./card_service"
  iam_role            = aws_iam_role.lookcard_ecs_task_role.arn
  default_listener    = aws_lb_listener.look-card.arn
  cluster             = aws_ecs_cluster.look_card.arn
  network = {
    vpc               = var.network.vpc
    private_subnet    = var.network.private_subnet
    public_subnet     = var.network.public_subnet
  }
  lookcardlocal_namespace_id = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
}

module "blockchain" {
  source              = "./blockchain_service"
  iam_role            = aws_iam_role.lookcard_ecs_task_role.arn
  default_listener    = aws_lb_listener.look-card.arn
  cluster             = aws_ecs_cluster.look_card.arn
  network = {
    vpc               = var.network.vpc
    private_subnet    = var.network.private_subnet
    public_subnet     = var.network.public_subnet
  }
  lookcardlocal_namespace_id = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
}

module "utility" {
  source              = "./utility_service"
  iam_role            = aws_iam_role.lookcard_ecs_task_role.arn
  default_listener    = aws_lb_listener.look-card.arn
  cluster             = aws_ecs_cluster.look_card.arn
  network = {
    vpc               = var.network.vpc
    private_subnet    = var.network.private_subnet
    public_subnet     = var.network.public_subnet
  }
  lookcardlocal_namespace_id = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
}


module "notification" {
  source              = "./notification_service"
  iam_role            = aws_iam_role.lookcard_ecs_task_role.arn
  default_listener    = aws_lb_listener.look-card.arn
  cluster             = aws_ecs_cluster.look_card.arn
  network = {
    vpc               = var.network.vpc
    private_subnet    = var.network.private_subnet
    public_subnet     = var.network.public_subnet
  }
  # lookcardlocal_namespace_id = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
}

module "user" {
  source              = "./user_service"
  iam_role            = aws_iam_role.lookcard_ecs_task_role.arn
  default_listener    = aws_lb_listener.look-card.arn
  cluster             = aws_ecs_cluster.look_card.arn
  network = {
    vpc               = var.network.vpc
    private_subnet    = var.network.private_subnet
    public_subnet     = var.network.public_subnet
  }
  lookcardlocal_namespace_id = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
}


module "reporting" {
  source              = "./reporting_service"
  iam_role            = aws_iam_role.lookcard_ecs_task_role.arn
  default_listener    = aws_lb_listener.look-card.arn
  cluster             = aws_ecs_cluster.look_card.arn
  network = {
    vpc               = var.network.vpc
    private_subnet    = var.network.private_subnet
    public_subnet     = var.network.public_subnet
  }
  # lookcardlocal_namespace_id = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
}