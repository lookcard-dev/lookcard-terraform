variable "vpc_id" {}
variable "lookcardlocal_namespace" {}
variable "cluster" {}
variable "sg_alb_id" {}
variable "secret_manager" {}
variable "env_tag" {}
variable "lookcard_log_bucket_name" {}

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
    name      = "reap-proxy"
    port      = 8080
    image     = var.image.url
    image_tag = var.image.tag
  }
  ecs_task_env_vars = [
  ]
  ecs_task_secret_vars = [
    {
      name      = "REAP_API_ENDPOINT"
      valueFrom = "${var.secret_manager.secret_arns["REAP"]}:API_ENDPOINT::"
    },
    {
      name      = "REAP_API_KEY"
      valueFrom = "${var.secret_manager.secret_arns["REAP"]}:API_KEY::"
    }
  ]
  iam_secrets = [
    var.secret_manager.secret_arns["REAP"]
  ]
  cloudwatch_log_groups = [
    aws_cloudwatch_log_group.ecs_log_group_reap_proxy.arn
  ]
}
