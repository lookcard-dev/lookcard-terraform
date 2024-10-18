variable "vpc_id" {}
variable "lookcardlocal_namespace" {}
variable "cluster" {}
variable "sg_alb_id" {}
variable "secret_manager" {}
variable "env_tag" {}
variable "redis_host" {}

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
    name      = "user-api"
    port      = 8080
    image     = var.image.url
    image_tag = var.image.tag
  }

  ecs_task_secret_vars = [
    {
      name      = "DATABASE_HOST"
      valueFrom = "${var.secret_manager.database_secret_arn}:host::"
    },
    {
      name      = "DATABASE_NAME"
      valueFrom = "${var.secret_manager.secret_arns["DATABASE"]}:host::"
    },
    {
      name      = "DATABASE_READ_HOST"
      valueFrom = "${var.secret_manager.secret_arns["DATABASE"]}:host::"
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
      valueFrom = "${var.secret_manager.secret_arns["SENTRY"]}:USER_API_DSN::"
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
      name  = "AWS_CLOUDWATCH_LOG_GROUP_NAME"
      value = "/lookcard/user-api"
    },
    {
      name  = "AWS_XRAY_DAEMON_ENDPOINT"
      value = "xray.daemon.lookcard.local:2337"
    },
    {
      name  = "REDIS_HOST"
      value = "lookcard-redis-cluster.abii1z.0001.apse1.cache.amazonaws.com:6379" #var.redis_host <- temp hardcode
    },
    {
      name  = "DATABASE_PORT"
      value = "5432"
    },
    {
      name  = "DATABASE_SCHEMA"
      value = "_user"
    },
    {
      name  = "DATABASE_USE_SSL"
      value = "true"
    }
  ]
  iam_secrets = [
    var.secret_manager.secret_arns["DATABASE"],
    var.secret_manager.secret_arns["SENTRY"],
  ]
}
