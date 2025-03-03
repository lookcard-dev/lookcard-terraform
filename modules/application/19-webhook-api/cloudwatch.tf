
resource "aws_cloudwatch_log_group" "webhook_api_access_log" {
  name              = "/apigw/webhook/access"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "app_log_group" {
  name = "/lookcard/${var.name}"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name = "/ecs/${var.name}"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}