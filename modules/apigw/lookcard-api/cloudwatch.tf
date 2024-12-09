resource "aws_cloudwatch_log_group" "api_gw_logs" {
  name              = "/aws/api-gateway/lookcard-api"
  retention_in_days = 30
}