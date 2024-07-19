variable "iam_role" {}

variable "cluster" {}

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

locals {
  application = {
    name      = "Notification"
    port      = 3001
    image     = var.image.url
    image_tag = var.image.tag
  }
  load_balancer = {
    api_path = ["/v2/api/notify-eh1gwoj67/*"]
    priority = 4
  }

  ecs_task_env_vars = [
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
    },
    {
      name  = "RUNTIME_ENVIRONMENT"
      value = "DEVELOP"
    }
  ]
}
