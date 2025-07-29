resource "aws_cloudwatch_log_group" "app_hourly_reconciliation_job" {
  name              = "/lookcard/cronjob/reconciliation/hourly"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "ecs_hourly_reconciliation_job" {
  name              = "/ecs/cronjob/reconciliation/hourly"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "app_daily_reconciliation_job" {
  name              = "/lookcard/cronjob/reconciliation/daily"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "ecs_daily_reconciliation_job" {
  name              = "/ecs/cronjob/reconciliation/daily"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}
