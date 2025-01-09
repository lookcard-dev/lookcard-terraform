variable "lookcardlocal_namespace" {}
variable "cluster" {}
variable "sg_alb_id" {}
variable "env_tag" {}
variable "secret_manager" {}
variable "bastion_sg" {}
variable "data_api_ecs_svc_sg" {
}
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
    name      = "notification-api"
    port      = 8080
    image     = var.image.url
    image_tag = var.image.tag
  }
  ecs_task_secret_vars = [
    {
      name      = "SENTRY_DSN"
      valueFrom = "${var.secret_manager.secret_arns["SENTRY"]}:NOTIFICATION_API_DSN::"
    },
    {
      name      = "POSTMARK_API_KEY"
      valueFrom = "${var.secret_manager.secret_arns["POSTMARK"]}:API_KEY::"
    },
    {
      name      = "TWILIO_ACCOUNT_SID"
      valueFrom = "${var.secret_manager.secret_arns["TWILIO"]}:ACCOUNT_SID::"
    },
    {
      name      = "TWILIO_AUTH_TOKEN"
      valueFrom = "${var.secret_manager.secret_arns["TWILIO"]}:AUTH_TOKEN::"
    },
    {
      name      = "TWILIO_MESSAGING_SERVICE_ID"
      valueFrom = "${var.secret_manager.secret_arns["TWILIO"]}:MESSAGING_SERVICE_ID::"
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
      value = aws_cloudwatch_log_group.application_log_group_notification_api.name
    }
  ]
  iam_secrets = [
    var.secret_manager.secret_arns["SENTRY"],
    var.secret_manager.secret_arns["POSTMARK"],
    var.secret_manager.secret_arns["TWILIO"],
  ]
  inbound_allow_sg_list = [
    data.aws_security_group.data_api_ecs_svc_sg.id,
    data.aws_security_group.bastion_sg.id,
  ]
}

data "aws_security_group" "data_api_ecs_svc_sg" {
  name = "data-api-ecs-svc-sg"
}
data "aws_security_group" "bastion_sg" {
  name = "bastion-security-group"
}


