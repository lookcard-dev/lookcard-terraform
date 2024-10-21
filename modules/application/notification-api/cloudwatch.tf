resource "aws_cloudwatch_log_group" "notification_v2" {
  name = "/ecs/${local.application.name}"
  retention_in_days = 30
}