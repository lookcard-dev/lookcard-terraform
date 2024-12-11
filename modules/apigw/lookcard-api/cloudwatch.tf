resource "aws_cloudwatch_log_group" "api_gw_logs" {
  name              = local.cloudwatch_log_group.name
  retention_in_days = 30
}