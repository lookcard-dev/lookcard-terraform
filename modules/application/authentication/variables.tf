
variable "vpc_id" {}
variable "aws_lb_listener_arn" {}
# variable "aws_lb_target_group_lookcard_tg_arn" {}

# variable "env" {}
# variable "Private-Subnet-1" {}

# variable "Private-Subnet-2" {}

# variable "Private-Subnet-3" {}

variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}
variable "iam_role" {}

# variable "subnet-pub-2" {}

# variable "subnet-pub-1" {}

# variable "ecs_security_groups" {}


# variable "ssl" {}

variable "cluster" {}
variable "sg_alb_id" {}
variable "sqs_withdrawal" {}

variable "env_secrets_arn" {}

variable "db_secret_secret_arn" {}

variable "token_secrets_arn" {}

# variable "alb_arn" {}

# variable "env" {}

# variable "cluster_name" {

# }





data "aws_ecr_image" "latest" {
  repository_name = "authentication-api"
  most_recent     = true
}

data "aws_secretsmanager_secret" "env_secret" {
  name = "ENV"
}
data "aws_secretsmanager_secret" "database_secret" {
  name = "DATABASE"
}
data "aws_secretsmanager_secret" "token_secret" {
  name = "TOKEN"
}


locals {
  environment_vars = [
    {
      name  = "AWS_REGION"
      value = "ap-southeast-1"
    },
    {
      name  = "SECRET_EXAMPLE_1"
      value = var.secret_arns["SECRET_EXAMPLE_1"]
    },

    {
      name  = "AWS_SECRET_ARN"
      value = data.aws_secretsmanager_secret.env_secret.arn
    },
    {
      name  = "AWS_DB_SECRET_ARN"
      value = data.aws_secretsmanager_secret.database_secret.arn
    },
    {
      name  = "AWS_TOKEN_SECRET_ARN"
      value = data.aws_secretsmanager_secret.token_secret.arn
    }
  ]
}
