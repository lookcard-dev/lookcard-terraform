variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
    database_subnet = list(string)
  })
}

data "aws_secretsmanager_secret_version" "database_secret_version" {
  secret_id = var.secret_manager.database_secret_id
}

locals {
  secret_values = jsondecode(data.aws_secretsmanager_secret_version.database_secret_version.secret_string)
  password      = local.secret_values["password"]
}

variable "secret_manager" {}
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