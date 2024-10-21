resource "aws_cloudwatch_log_group" "ecs_log_group_referral_api" {
  name = "/ecs/${local.application.name}"
}