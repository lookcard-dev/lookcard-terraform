variable "api_lookcardlocal_namespace" {}
variable "dynamodb_profile_data_table_name" {}
variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}

variable "default_listener" {}
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
      name  = "AWS_DYNAMODB_PROFILE_DATA_TABLE_NAME"
      value = var.dynamodb_profile_data_table_name
    },
    {
      name  = "AWS_XRAY_DAEMON_ENDPOINT"
      value = "xray.daemon.lookcard.local:2337"
    },
    {
      name  = "RUNTIME_ENVIRONMENT"
      value = "DEVELOP"
    }
  ]
  ecs_task_secret_vars = [
    {
      name      = "SENTRY_DSN"
      valueFrom = "${var.secret_manager.sentry_secret_arn}:PROFILE_API_DSN::"
    }
  ]
}
