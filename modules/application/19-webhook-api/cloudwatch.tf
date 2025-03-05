
resource "aws_cloudwatch_log_group" "webhook_api_access_log" {
  name              = "/apigw/webhook/access"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "app_log_group" {
  name              = "/lookcard/${var.name}"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.name}"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "sumsub_webhook_firehose_log_group" {
  name              = "/aws/kinesisfirehose/webhook/sumsub"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "reap_webhook_firehose_log_group" {
  name              = "/aws/kinesisfirehose/webhook/reap"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

resource "aws_cloudwatch_log_group" "firebase_webhook_firehose_log_group" {
  name              = "/aws/kinesisfirehose/webhook/firebase"
  retention_in_days = var.runtime_environment == "production" ? 30 : 3
}

