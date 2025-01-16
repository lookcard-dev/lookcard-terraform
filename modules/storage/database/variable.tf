variable "aws_provider" {
  type = object({
    region     = string
    account_id = string
  })
}

variable "runtime_environment" {
  type = string
  validation {
    condition     = contains(["develop", "testing", "staging", "production", "sandbox"], var.runtime_environment)
    error_message = "runtime_environment must be one of: develop, testing, staging, production, or sandbox"
  }
}

variable "vpc_id"{
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

data "aws_secretsmanager_secret_version" "database_secret_version" {
  secret_id = var.secret_manager.database_secret_id
}

locals {
  secret_values = jsondecode(data.aws_secretsmanager_secret_version.database_secret_version.secret_string)
  password      = local.secret_values["password"]
}

# variable "secret_manager" {}
# variable "websoclet_table_name" {
#   type    = string
#   default = "WebSocket"
# }
# variable "dynamodb_config" {
#   type = object({
#     enable_autoscaling = bool
#   })
#   default = {
#     enable_autoscaling = false
#   }
# }
# output "dynamodb_table_arn" {
#   value = aws_dynamodb_table.websocket.arn
# }