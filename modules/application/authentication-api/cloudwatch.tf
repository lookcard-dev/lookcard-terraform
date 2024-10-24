resource "aws_cloudwatch_log_group" "ecs_log_group_authentication_api" {
  name = "/ecs/${local.application.name}"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "application_log_group_authentication_api" {
  name = "/lookcard/${local.application.name}"
  retention_in_days = 30
}