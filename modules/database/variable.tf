# variable "Database-Sub-1" {}
# variable "Database-Sub-2" {}
# variable "Database-Sub-3" {}

# variable "rds_security_group-1" {}





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
