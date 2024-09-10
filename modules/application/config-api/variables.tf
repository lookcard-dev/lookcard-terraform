variable "sg_alb_id" {}
variable "lookcardlocal_namespace" {}
variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}
variable "default_listener" {}
variable "dynamodb_config_api_config_data_name" {}
variable "dynamodb_config_api_config_data_arn" {}
variable "acm" {}
variable "cluster" {}
variable "secret_manager" {}
variable "env_tag" {}
variable "image" {
  type = object({
    url = string
    tag = string
  })
}

locals {
  application = {
    name      = "config-api"
    port      = 8080
    image     = var.image.url
    image_tag = var.image.tag
  }
  load_balancer = {
    config_api_path = ["/configs", "/configs/*"]
    config_priority = 301
  }
  ecs_task_secret_vars = [
    {
      name      = "SENTRY_DSN"
      valueFrom = "${var.secret_manager.secret_arns["SENTRY"]}:CONFIG_API_DSN::"
    }
  ]
  ecs_task_env_vars = [
    {
      name  = "AWS_REGION"
      value = "ap-southeast-1"
    },
    {
      name  = "AWS_DYNAMODB_CONFIG_DATA_TABLE_NAME"
      value = var.dynamodb_config_api_config_data_name
      }, {
      name  = "CORS_ORIGINS"
      value = "https://${var.acm.domain_api_name}"
      }, {
      name  = "AWS_CLOUDWATCH_LOG_GROUP_NAME"
      value = aws_cloudwatch_log_group.config_api.name
    },
    {
      name  = "AWS_XRAY_DAEMON_ENDPOINT"
      value = "xray.daemon.lookcard.local:2337"
    },
    {
      name  = "RUNTIME_ENVIRONMENT"
      value = var.env_tag
    }
  ]
}

