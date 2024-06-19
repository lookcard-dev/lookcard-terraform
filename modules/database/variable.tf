# variable "Database-Sub-1" {}
# variable "Database-Sub-2" {}
# variable "Database-Sub-3" {}

# variable "rds_security_group-1" {}
variable "lookcard_db_secret" {}

variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}


variable "websoclet_table_name" {
  type    = string
  default = "WebSocket"
}


variable "dynamodb_config" {
  type = object({
    enable_autoscaling = bool
  })
  default = {
    enable_autoscaling = false
  }
}

output "dynamodb_table_arn" {
  value = aws_dynamodb_table.websocket.arn
}
