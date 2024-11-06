variable "vpc_id" {}
variable "lookcardlocal_namespace" {}
variable "cluster" {}
variable "sg_alb_id" {}
variable "secret_manager" {}
variable "env_tag" {}
variable "lambda_aggregator_tron_sg_id" {}

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
    name      = "authentication-api"
    port      = 8080
    image     = var.image.url
    image_tag = var.image.tag
  }

  ecs_task_secret_vars = [
    {
      name      = "SENTRY_DSN"
      valueFrom = "${var.secret_manager.secret_arns["SENTRY"]}:AUTHENTICATION_API_SDN::"
    },
    {
      name      = "FIREBASE_CREDENTIALS"
      valueFrom = "${var.secret_manager.secret_arns["FIREBASE"]}:CREDENTIALS::"
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
      value = aws_cloudwatch_log_group.application_log_group_authentication_api.name
    }
  ]
  iam_secrets = [
    var.secret_manager.secret_arns["FIREBASE"],
    var.secret_manager.secret_arns["SENTRY"],
  ]
}
