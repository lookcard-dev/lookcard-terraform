variable "default_listener" {}
variable "vpc_id" {}
variable "lookcardlocal_namespace" {}
variable "sg_alb_id" {}
variable "cluster" {}
variable "secret_manager" {}
variable "sqs" {}
variable "acm" {}
variable "env_tag" {}
variable "redis_host" {}
variable "rds_aurora_postgresql_writer_endpoint" {}
variable "rds_aurora_postgresql_reader_endpoint" {}
# variable "rds_proxy_host" {}
# variable "rds_proxy_read_host" {}
variable "reseller_api_sg" {}
variable "bastion_sg" {}
variable "lambda_cryptocurrency_sweeper" {}
variable "lambda_cryptocurrency_withdrawal" {}
variable "crypto_api_module" {}
variable "reseller_api_module" {}

variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}

variable "image" {
  type = object({
    url = string
    tag = string
  })
}

locals {
  application = {
    name      = "account-api"
    port      = 8080
    image     = var.image.url
    image_tag = var.image.tag
  }
  load_balancer = {
    api_path = ["/accounts", "/account", "/account/*"]
  }
  ecs_task_secret_vars = [
    {
      name      = "DATABASE_NAME"
      valueFrom = "${var.secret_manager.secret_arns["DATABASE"]}:dbname::"
    },
    {
      name      = "DATABASE_USERNAME"
      valueFrom = "${var.secret_manager.secret_arns["DATABASE"]}:username::"
    },
    {
      name      = "DATABASE_PASSWORD"
      valueFrom = "${var.secret_manager.secret_arns["DATABASE"]}:password::"
    },
    {
      name      = "SENTRY_DSN"
      valueFrom = "${var.secret_manager.secret_arns["SENTRY"]}:ACCOUNT_API_DSN::"
    }
  ]
  ecs_task_env_vars = [
    {
      name  = "PORT"
      value = "8080"
    },
    {
      name  = "CORS_ORIGINS"
      value = "*"
    },
    {
      name  = "RUNTIME_ENVIRONMENT"
      value = var.env_tag
    },
    {
      name  = "AWS_XRAY_DAEMON_ENDPOINT"
      value = "xray.daemon.lookcard.local:2337"
    },
    {
      name  = "AWS_CLOUDWATCH_LOG_GROUP_NAME"
      value = aws_cloudwatch_log_group.application_log_group_account_api.name
    },
    {
      name  = "REDIS_HOST"
      value = var.redis_host
    },
    {
      name  = "DATABASE_HOST"
      value = var.rds_aurora_postgresql_writer_endpoint
    },
    {
      name  = "DATABASE_READ_HOST"
      value = var.rds_aurora_postgresql_reader_endpoint
    },
    {
      name  = "DATABASE_PORT"
      value = "5432"
    },
    {
      name  = "DATABASE_SCHEMA"
      value = "account"
    },
    {
      name  = "DATABASE_USE_SSL"
      value = "true"
    }
  ]
  iam_secrets = [
    var.secret_manager.secret_arns["DATABASE"],
    var.secret_manager.secret_arns["SENTRY"]
  ]
  inbound_allow_sg_list = [
    var.crypto_api_module.crypto_api_ecs_svc_sg.id,
    var.reseller_api_module.reseller_api_ecs_svc_sg.id,
    var.bastion_sg
    # Missing app api sg
  ]
}

