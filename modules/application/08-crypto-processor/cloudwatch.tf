resource "aws_cloudwatch_log_group" "sweep_processor_app_log_group" {
  name = "/lookcard/${var.name}"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "sweep_processor_lambda_log_group" {
  name              = "/aws/lambda/Crypto_Processor-Sweep_Processor"
  retention_in_days = 30
}
