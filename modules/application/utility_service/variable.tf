variable "iam_role" {}
variable "lookcardlocal_namespace_id" {}
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
locals {
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