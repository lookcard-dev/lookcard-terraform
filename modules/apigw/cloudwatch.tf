resource "aws_cloudwatch_log_group" "api_gw_logs" {
  name              = "/aws/api-gateway/lookcard"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "sumsub_webhook" {
  name              = "/aws/api-gateway/sumsub_webhook"
  retention_in_days = 30
}