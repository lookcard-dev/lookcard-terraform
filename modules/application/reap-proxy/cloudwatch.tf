resource "aws_cloudwatch_log_group" "ecs_log_group_reap_proxy" {
  name = "/ecs/${local.application.name}"
  retention_in_days = 30
}