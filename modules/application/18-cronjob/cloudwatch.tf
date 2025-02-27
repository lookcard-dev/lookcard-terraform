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

resource "aws_cloudwatch_log_group" "account_api_ecs_log_group" {
  name              = "/ecs/cronjob/account-api"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "account_api_app_log_group" {
  name              = "/lookcard/cronjob/account-api"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "batch_retry_wallet_deposit_processor_app_log_group" {
  name              = "/lookcard/cronjob/batch_retry_wallet_deposit_processor"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "batch_retry_wallet_deposit_processor_ecs_log_group" {
  name              = "/ecs/cronjob/batch_retry_wallet_deposit_processor"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "crypto_api_ecs_log_group" {
  name              = "/ecs/cronjob/crypto-api"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "crypto_api_app_log_group" {
  name              = "/lookcard/cronjob/crypto-api"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "batch_retry_wallet_withdrawal_processor_app_log_group" {
  name              = "/lookcard/cronjob/batch_retry_wallet_withdrawal_processor"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "batch_retry_wallet_withdrawal_processor_ecs_log_group" {
  name              = "/ecs/cronjob/batch_retry_wallet_withdrawal_processor"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}
