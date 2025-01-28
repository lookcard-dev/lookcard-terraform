resource "aws_cloudwatch_log_group" "firebase_log_group" {
  name = "/lookcard/apigw-authorizer/firebase"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}