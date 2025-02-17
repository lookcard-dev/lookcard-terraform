resource "aws_cloudwatch_log_group" "batch_account_snapshot_processor_app_log_group" {
  name              = "/lookcard/cronjob/batch_account_snapshot_processor"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "batch_account_snapshot_processor_ecs_log_group" {
  name              = "/ecs/cronjob/batch_account_snapshot_processor"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "batch_account_statement_generator_app_log_group" {
  name              = "/lookcard/cronjob/batch_account_statement_generator"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "batch_account_statement_generator_ecs_log_group" {
  name              = "/ecs/cronjob/batch_account_statement_generator"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

