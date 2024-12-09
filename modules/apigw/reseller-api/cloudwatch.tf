resource "aws_cloudwatch_log_group" "reseller_api" {
  name              = "/aws/api-gateway/reseller-api"
  retention_in_days = 30
}