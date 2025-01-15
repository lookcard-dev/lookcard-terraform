variable "vpc_id" {}
variable "lookcardlocal_namespace" {}
variable "sg_alb_id" {}
variable "cluster" {}
variable "secret_manager" {}
variable "crypto_api_module" {}
variable "reseller_api_module" {}
variable "env_tag" {}

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
    name      = "edns-api"
    port      = 8080
    image     = var.image.url
    image_tag = var.image.tag
  }
  ecs_task_secret_vars = [
    {
      name      = "SENTRY_DSN"
      valueFrom = "${var.secret_manager.secret_arns["SENTRY"]}:EDNS_API_DSN::"
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
      name= "AWS_DYNAMODB_DOMAIN_TABLE_NAME"
      value = aws_dynamodb_table.edns_api_domain_data.name
    },
    {
      name  = "AWS_CLOUDWATCH_LOG_GROUP_NAME"
      value = aws_cloudwatch_log_group.application_log_group_edns_api.name
    },

  ]
  iam_secrets = [
    var.secret_manager.secret_arns["SENTRY"]
  ]
  
  inbound_allow_sg_list = [
    data.aws_security_group.reseller_api_sg.id, 
    data.aws_security_group.bastion_sg.id
  ]
}


data "aws_security_group" "reseller_api_sg" {
  name = "reseller-api-security-group"
}

data "aws_security_group" "bastion_sg" {
  name = "bastion-security-group"
}
