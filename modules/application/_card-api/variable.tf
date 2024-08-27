variable "iam_role" {}
variable "default_listener" {}
variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}
variable "lookcardlocal_namespace" {}
variable "cluster" {}
variable "secret_manager" {}
variable "image" {
  type = object({
    url = string
    tag = string
  })
}
locals {
  application = {
    name      = "Card"
    port      = 8000
    image     = var.image.url
    image_tag = var.image.tag
  }
  load_balancer = {
    api_path = ["/v2/api/card-ywso44nnn/*"]
    priority = 5
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
