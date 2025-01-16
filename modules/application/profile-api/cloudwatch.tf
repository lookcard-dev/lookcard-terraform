resource "aws_cloudwatch_log_group" "app_log_group" {
  name = "/lookcard/${local.application.name}"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name = "/ecs/${local.application.name}"
  retention_in_days = 30
}