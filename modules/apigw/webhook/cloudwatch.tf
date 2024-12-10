resource "aws_cloudwatch_log_group" "webhook" {
  name              = local.cloudwatch_log_group.name
  retention_in_days = local.cloudwatch_log_group.retention_in_days
}