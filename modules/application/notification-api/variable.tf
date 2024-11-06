variable "iam_role" {}
variable "env_tag" {}
variable "cluster" {}
variable "sg_alb_id" {}
variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}

variable "default_listener" {}
variable "secret_manager" {}

variable "image" {
  type = object({
    url = string
    tag = string
  })
}

variable "bastion_sg" {}

locals {
  application = {
    name      = "notification-v2"
    port      = 8080
    image     = var.image.url
    image_tag = var.image.tag
  }
  load_balancer = {
    api_path = ["/v2/api/notify-v2/*"]
    priority = 11
  }
  ecs_task_secret_vars = [
    {
      name      = "SENDGRID_API_KEY"
      valueFrom = "${var.secret_manager.secret_arns["SENDGRID"]}:SENDGRID_API_KEY::"
    },
    {
      name      = "FIREBASE_CREDENTIALS"
      valueFrom = "${var.secret_manager.secret_arns["FIREBASE"]}:CREDENTIALS::"
    },
    {
      name      = "FIREBASE_PROJECT_ID"
      valueFrom = "${var.secret_manager.secret_arns["FIREBASE"]}:PROJECT_ID::"
    },
    {
      name      = "FIREBASE_SERVICE_ACCOUNT_CLIENT_EMAIL"
      valueFrom = "${var.secret_manager.secret_arns["FIREBASE"]}:SERVICE_ACCOUNT_CLIENT_EMAIL::"
    },
    {
      name      = "FIREBASE_SERVICE_ACCOUNT_PRIVATE_KEY"
      valueFrom = "${var.secret_manager.secret_arns["FIREBASE"]}:SERVICE_ACCOUNT_PRIVATE_KEY::"
    }

  ]
  ecs_task_env_vars = [
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
    },
    {
      name  = "RUNTIME_ENVIRONMENT"
      value = var.env_tag
    }
  ]
}