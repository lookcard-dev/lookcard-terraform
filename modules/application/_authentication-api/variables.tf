
variable "vpc_id" {}
variable "aws_lb_listener_arn" {}
variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
    public_subnet_cidr_list   = list(string)
  })
}
variable "iam_role" {}
variable "cluster" {}
variable "sg_alb_id" {}
variable "secret_manager" {}
variable "sqs" {}
variable "image" {
  type = object({
    url = string
    tag = string
  })
}

locals {
    application = {
    name      = "authentication-api"
    port      = 8000
    image     = var.image.url
    image_tag = var.image.tag
  }
  load_balancer = {
    api_path = ["/v2/api/auth-zqg2muwph/*"]
    priority = 4
  }
  iam_secrets = [
    var.secret_manager.secret_arns["ENV"],
    var.secret_manager.secret_arns["TOKEN"],
    var.secret_manager.secret_arns["DATABASE"],
    var.secret_manager.secret_arns["AML_ENV"]
  ]
  ecs_task_secret_vars = [
    {
      name  = "AWS_REGION"
      value = "ap-southeast-1"
    },
    {
      name  = "SECRETS_MANAGER_ENV_ARN"
      value = var.secret_manager.secret_arns["ENV"]
    },
    {
      name  = "SECRETS_MANAGER_DB_ARN"
      value = var.secret_manager.secret_arns["DATABASE"]
    },
    {
      name  = "SECRETS_MANAGER_TOKEN_ARN"
      value = var.secret_manager.secret_arns["TOKEN"]
    }
  ]
}
variable "cluster_name" {}