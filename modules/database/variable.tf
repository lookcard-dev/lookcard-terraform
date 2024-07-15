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


variable "lookcard_rds_password" {}
