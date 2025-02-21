resource "aws_cloudwatch_log_group" "sweep_processor_app_log_group" {
  name              = "/lookcard/crypto-processor/sweep"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "sweep_processor_lambda_log_group" {
  name              = "/aws/lambda/Crypto_Processor-Sweep_Processor"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "withdrawal_processor_app_log_group" {
  name              = "/lookcard/crypto-processor/withdrawal"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "withdrawal_processor_lambda_log_group" {
  name              = "/aws/lambda/Crypto_Processor-Withdrawal_Processor"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}