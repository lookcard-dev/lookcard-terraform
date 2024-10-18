resource "aws_cloudwatch_log_group" "ecs_log_group_user_api" {
  name = "/ecs/${local.application.name}"
}

resource "aws_cloudwatch_log_group" "application_log_group_user_api" {
  name = "/lookcard/${local.application.name}"
}