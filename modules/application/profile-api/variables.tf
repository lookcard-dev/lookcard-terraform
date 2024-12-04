variable "sg_alb_id" {}
variable "lookcardlocal_namespace" {}
variable "secret_manager" {}
variable "referral_api_sg" {}
variable "account_api_sg" {}
variable "user_api_sg"{}
# variable "_auth_api_sg" {}
variable "verification_api_sg" {}
variable "env_tag" {}
variable "reseller_api_sg" {}
variable "lambda_firebase_authorizer_sg_id" {}
variable "bastion_sg" {}
variable "crypto_api_sg_id" {}
variable "lambda_cryptocurrency_sweeper" {}

variable "crypto_api_module" {}
variable "user_api_module" {}
variable "account_api_module" {}
variable "reseller_api_module" {}
variable "firebase_authorizer_module" {}


variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}

variable "default_listener" {}
variable "cluster" {}


variable "image" {
  type = object({
    url = string
    tag = string
  })
}

locals {
  application = {
    name      = "profile-api"
    port      = 8080
    image     = var.image.url
    image_tag = var.image.tag
  }
  load_balancer = {
    profile_api_path = ["/profiles", "/profiles/*"]
    profile_priority = 201
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
      value = aws_cloudwatch_log_group.application_log_group_profile_api.name
    },
    {
      name  = "AWS_DYNAMODB_PROFILE_DATA_TABLE_NAME"
      value = aws_dynamodb_table.profile_data.name
    }
  ]
  ecs_task_secret_vars = [
    {
      name      = "SENTRY_DSN"
      valueFrom = "${var.secret_manager.secret_arns["SENTRY"]}:PROFILE_API_DSN::"
    }
  ]
  inbound_allow_sg_list = [
    var.crypto_api_module.crypto_api_ecs_svc_sg.id,
    var.user_api_module.user_api_ecs_svc_sg.id,
    var.account_api_module.account_api_ecs_svc_sg.id,
    var.bastion_sg,
    var.reseller_api_module.reseller_api_ecs_svc_sg.id,
    var.firebase_authorizer_module.firebase_authorizer_lambda_func_sg.id
    # Missing app-api, firehose-webhook
  ]
}
