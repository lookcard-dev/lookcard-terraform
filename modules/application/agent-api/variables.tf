variable "vpc_id" {}
variable "lookcardlocal_namespace" {}
variable "cluster" {}
variable "sg_alb_id" {}
variable "secret_manager" {}
variable "env_tag" {}
variable "redis_host" {}
variable "rds_aurora_postgresql_writer_endpoint" {}
variable "rds_aurora_postgresql_reader_endpoint" {}
variable "rds_proxy_host" {}
variable "rds_proxy_read_host" {}
variable "_auth_api_sg" {}

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
    name      = "agent-api"
    port      = 8080
    image     = var.image.url
    image_tag = var.image.tag
  }
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
      value = aws_cloudwatch_log_group.application_log_group_agent_api.name
    },
    {
      name  = "REDIS_HOST"
      value = var.redis_host
    },
    {
      name  = "DATABASE_HOST"
      value = var.rds_proxy_host
    },
    {
      name  = "DATABASE_READ_HOST"
      value = var.rds_proxy_read_host
    },
    {
      name  = "DATABASE_PORT"
      value = "5432"
    },
    {
      name  = "DATABASE_SCHEMA"
      value = "agent"
    },
    {
      name  = "DATABASE_USE_SSL"
      value = "true"
    },
    {
      name  = "BOT_TOKEN"
      value = "5000925898:AAFExCrrpAmGfKZMaMPHqCC0ixkuHXgiSwU"
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
    # {
    #   name      = "SENTRY_DSN"
    #   valueFrom = "${var.secret_manager.secret_arns["SENTRY"]}:REFERRAL_API_DSN::"
    # }
  ]
  iam_secrets = [
    var.secret_manager.secret_arns["DATABASE"],
    var.secret_manager.secret_arns["SENTRY"]
  ]
}
