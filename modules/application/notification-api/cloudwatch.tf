resource "aws_cloudwatch_log_group" "application_log_group_notification_api" {
  name = "/ecs/${local.application.name}"
  retention_in_days = 30
}
