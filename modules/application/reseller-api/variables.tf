variable "vpc_id" {}
variable "lookcardlocal_namespace" {}
variable "cluster" {}
variable "sg_alb_id" {}
variable "secret_manager" {}
variable "env_tag" {}
variable "redis_host" {}
variable "rds_aurora_postgresql_writer_endpoint" {}
variable "rds_aurora_postgresql_reader_endpoint" {}
# variable "rds_proxy_host" {}
# variable "rds_proxy_read_host" {}
# variable "_auth_api_sg" {}
variable "default_listener" {}
variable "bastion_sg" {}

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
    name      = "reseller-api"
    port      = 8080
    image     = var.image.url
    image_tag = var.image.tag
  }
  load_balancer = {
    api_path = ["/agent/*", "/agents/*", "/agent", "/agents", "/healthcheckz"]
    priority = 300
  }
  ecs_task_env_vars = [
    {
      name  = "PORT"
      value = "8080"
    },
    {
      name  = "CORS_ORIGINS"
      value = "*,https://7649-2-58-242-76.ngrok-free.app,https://d11w961ys8kzxr.cloudfront.net"
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
      value = aws_cloudwatch_log_group.application_log_group_reseller_api.name
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
      value = "reseller"
    },
    {
      name  = "DATABASE_USE_SSL"
      value = "true"
    },
    {
      name  = "PROFILE_API_PROTOCOL"
      value = "http"
    },
    {
      name  = "PROFILE_API_HOST"
      value = "profile.api.lookcard.local"
    },
    {
      name  = "PROFILE_API_PORT"
      value = "8080"
    },
    {
      name  = "ACCOUNT_API_PROTOCOL"
      value = "http"
    },
    {
      name  = "ACCOUNT_API_HOST"
      value = "account.api.lookcard.local"
    },
    {
      name  = "ACCOUNT_API_PORT"
      value = "8080"
    },
    {
      name  = "CRYPTO_API_PROTOCOL"
      value = "http"
    },
    {
      name  = "CRYPTO_API_HOST"
      value = "crypto.api.lookcard.local"
    },
    {
      name  = "CRYPTO_API_PORT"
      value = "8080"
    },
    {
      name  = "REFERRAL_API_PROTOCOL"
      value = "http"
    },
    {
      name  = "REFERRAL_API_HOST"
      value = "referral.api.lookcard.local"
    },
    {
      name  = "REFERRAL_API_PORT"
      value = "8080"
    },
    {
      name  = "USER_API_PROTOCOL"
      value = "http"
    },
    {
      name  = "USER_API_HOST"
      value = "user.api.lookcard.local"
    },
    {
      name  = "USER_API_PORT"
      value = "8080"
    }
  ]
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
      name      = "BOT_TOKEN"
      valueFrom = "${var.secret_manager.secret_arns["TELEGRAM"]}:reseller-bot-token::"
    }
    # {
    #   name      = "SENTRY_DSN"
    #   valueFrom = "${var.secret_manager.secret_arns["SENTRY"]}:REFERRAL_API_DSN::"
    # }
  ]
  iam_secrets = [
    var.secret_manager.secret_arns["DATABASE"],
    var.secret_manager.secret_arns["SENTRY"],
    var.secret_manager.secret_arns["TELEGRAM"]
  ]
}
