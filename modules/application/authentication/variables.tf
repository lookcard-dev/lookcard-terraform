
variable "vpc_id" {}
variable "aws_lb_listener_arn" {}
variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}
variable "iam_role" {}
variable "cluster" {}
variable "sg_alb_id" {}
variable "sqs_withdrawal" {}
variable "secret_manager" {}

variable "image" {
  type = object({
    url = string
    tag = string
  })
}

locals {
    application = {
    name      = "Authentication"
    port      = 8000
    image     = var.image.url
    image_tag = var.image.tag
  }
  load_balancer = {
    api_path = ["/v2/api/auth-zqg2muwph/*"]
    priority = 4
  }
  iam_secrets = [
    {
      arn   = var.secret_manager.env_secret_arn
    },
    {
      arn   = var.secret_manager.token_secret_arn
    },
    {
      arn   = var.secret_manager.database_secret_arn
    },
    {
      arn   = var.secret_manager.aml_env_secret_arn
    }
  ]
  ecs_task_secret_vars = [
    {
      name  = "AWS_REGION"
      value = "ap-southeast-1"
    },
    {
      name  = "AWS_SECRET_ARN"
      value = var.secret_manager.env_secret_arn
    },
    {
      name  = "AWS_DB_SECRET_ARN"
      value = var.secret_manager.database_secret_arn
    },
    {
      name  = "AWS_TOKEN_SECRET_ARN"
      value = var.secret_manager.token_secret_arn
    }
  ]
}
