resource "aws_cloudwatch_log_group" "webhook" {
  name              = "/aws/api-gateway/webhook"
  retention_in_days = 30
}