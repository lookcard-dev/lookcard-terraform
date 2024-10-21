resource "aws_cloudwatch_log_group" "xray_daemon" {
  name = "/ecs/xray-daemon"
  retention_in_days = 30
}