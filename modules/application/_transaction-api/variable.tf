variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}

variable "default_listener" {}

variable "iam_role" {}
variable "cluster" {}
variable "sg_alb_id" {}
variable "vpc_id" {}
variable "lookcardlocal_namespace" {}
variable "secret_manager" {}
variable "image" {
  type = object({
    url = string
    tag = string
  })
}
locals {
  application = {
    name      = "_transaction-api"
    port      = 3000
    image     = var.image.url
    image_tag = var.image.tag
  }
  load_balancer = {
    api_path = ["/v2/api/tran-m13unmbb2/*"]
    priority = 7
  }
  ecs_task_secret_vars = [
    {
      name  = "AWS_REGION"
      value = "ap-southeast-1"
    },
    {
      name  = "AWS_SECRET_ARN"
      value = var.secret_manager.secret_arns["ENV"]
    },
    {
      name  = "AWS_DB_SECRET_ARN"
      value = var.secret_manager.secret_arns["DATABASE"]
    },
    {
      name  = "AWS_TOKEN_SECRET_ARN"
      value = var.secret_manager.secret_arns["TOKEN"]
    }
  ]
}