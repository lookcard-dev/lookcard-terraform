
variable "vpc_id" {}

variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}
variable "cluster" {}

variable "dynamodb_crypto_transaction_listener_arn" {}
variable "secret_manager" {}

variable "image" {
  type = object({
    url = string
    tag = string
  })
}
locals {
  nile-trongrid = {
    name      = "tron-nile-trongrid"
    port      = 8080
    image     = var.image.url
    image_tag = var.image.tag
  }
  nile-getblock = {
    name      = "tron-nile-getblock"
    port      = 8080
    image     = var.image.url
    image_tag = var.image.tag
  }

  ecs_task_env_vars_trongrid = [
    {
      name  = "RUNTIME_ENVIRONMENT"
      value = var.env_tag
    },
    {
      name  = "AWS_CLOUDWATCH_LOG_GROUP_NAME"
      value = aws_cloudwatch_log_group.application_log_crypto_listener_trongrid.name
    },
    {
      name  = "DATABASE_HOST"
      value = var.rds_aurora_postgresql_writer_endpoint
    },
    {
      name  = "DATABASE_READ_HOST"
      value = var.rds_aurora_postgresql_reader_endpoint
    },
    {
      name  = "DATABASE_PORT"
      value = "5432"
    },
    {
      name  = "DATABASE_SCHEMA"
      value = "crypto_listener"
    },
    {
      name  = "DATABASE_USE_SSL"
      value = "true"
    },
    {
      name  = "NODE_ID"
      value = "tron-nile-trongrid"
    },
    {
      name  = "NODE_ECO"
      value = "tron"
    },
    {
      name  = "NODE_BLOCKCHAIN_ID"
      value = "tron-nile"
    }
  ]
  ecs_task_env_vars_getblock = [
    {
      name  = "RUNTIME_ENVIRONMENT"
      value = var.env_tag
    },
    {
      name  = "AWS_CLOUDWATCH_LOG_GROUP_NAME"
      value = aws_cloudwatch_log_group.application_log_crypto_listener_getblock.name
    },
    {
      name  = "DATABASE_HOST"
      value = var.rds_aurora_postgresql_writer_endpoint
    },
    {
      name  = "DATABASE_READ_HOST"
      value = var.rds_aurora_postgresql_reader_endpoint
    },
    {
      name  = "DATABASE_PORT"
      value = "5432"
    },
    {
      name  = "DATABASE_SCHEMA"
      value = "crypto_listener"
    },
    {
      name  = "DATABASE_USE_SSL"
      value = "true"
    },
    {
      name  = "NODE_ID"
      value = "tron-nile-getblock"
    },
    {
      name  = "NODE_ECO"
      value = "tron"
    },
    {
      name  = "NODE_BLOCKCHAIN_ID"
      value = "tron-nile"
    }
  ]
  ecs_task_secret_vars_trongrid = [
    {
      name      = "DATABASE_NAME"
      valueFrom = "${var.secret_manager.secret_arns["DATABASE"]}:dbname::"
    },
    {
      name      = "DATABASE_USERNAME"
      valueFrom = "${var.secret_manager.secret_arns["DATABASE"]}:username::"
    },
    {
      name      = "DATABASE_PASSWORD"
      valueFrom = "${var.secret_manager.secret_arns["DATABASE"]}:password::"
    },
    {
      name      = "TRONGRID_API_KEY"
      valueFrom = "${var.secret_manager.secret_arns["TRONGRID"]}:API_KEY::"
    },
    {
      name      = "RPC_ENDPOINT"
      valueFrom = "${var.secret_manager.secret_arns["TRONGRID"]}:NILE_JSON_RPC_HTTP_ENDPOINT::"
    }
  ]
  ecs_task_secret_vars_getblock = [
    {
      name      = "DATABASE_NAME"
      valueFrom = "${var.secret_manager.secret_arns["DATABASE"]}:dbname::"
    },
    {
      name      = "DATABASE_USERNAME"
      valueFrom = "${var.secret_manager.secret_arns["DATABASE"]}:username::"
    },
    {
      name      = "DATABASE_PASSWORD"
      valueFrom = "${var.secret_manager.secret_arns["DATABASE"]}:password::"
    },
    {
      name      = "RPC_ENDPOINT"
      valueFrom = "${var.secret_manager.secret_arns["GET_BLOCK"]}:TRON_NILE_JSON_RPC_HTTP_ENDPOINT::"
    }
  ]
  iam_secrets_getblock = [
    var.secret_manager.secret_arns["DATABASE"],
    var.secret_manager.secret_arns["GET_BLOCK"]
  ]
  iam_secrets_trongrid = [
    var.secret_manager.secret_arns["DATABASE"],
    var.secret_manager.secret_arns["TRONGRID"]
  ]
}
variable "sqs" {}
variable "capacity_provider_ec2_arm64_on_demand" {}
variable "capacity_provider_ec2_amd64_on_demand" {}
variable "rds_aurora_postgresql_writer_endpoint" {}
variable "rds_aurora_postgresql_reader_endpoint" {}
variable "env_tag" {}
