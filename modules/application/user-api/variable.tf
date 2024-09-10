variable "vpc_id" {}
variable "lookcardlocal_namespace" {}
variable "cluster" {}
variable "sg_alb_id" {}
variable "secret_manager" {}

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
      valueFrom = "${var.secret_manager.secret_arns["SENTRY"]}:CONFIG_API_DSN::"
    }
  ]
  ecs_task_env_vars = [
    {
      name  = "RUNTIME_ENVIRONMENT"
      value = ""
    },
    {
      name  = "AWS_XRAY_DAEMON_ENDPOINT"
      value = "xray.daemon.lookcard.local:2337"
    },
    {
      name  = "DATABASE_SCHEMA"
      value = "_user"
    },
    {
      name  = "DATABASE_USE_SSL"
      value = "true"
    },
  ]
  iam_secrets = [
    var.secret_manager.secret_arns["DATABASE"],
    var.secret_manager.secret_arns["SENTRY"],
  ]
}
