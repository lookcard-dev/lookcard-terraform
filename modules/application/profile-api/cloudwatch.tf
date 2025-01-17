resource "aws_cloudwatch_log_group" "app_log_group" {
  name = "/lookcard/${var.name}"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name = "/ecs/${var.name}"
  retention_in_days = 30
}