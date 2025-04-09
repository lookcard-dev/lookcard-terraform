resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.name}"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}