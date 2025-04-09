resource "aws_cloudwatch_log_group" "app_log_group" {
  name              = "/lookcard/${var.name}"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.name}"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "api_gateway_log_group" {
  name              = "/aws/api-gateway/${var.name}"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

