resource "aws_cloudwatch_log_group" "application_log_group_crypto_api" {
  name = "/lookcard/${local.application.name}"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "ecs_log_group_crypto_api" {
  name = "/ecs/${local.application.name}"
  retention_in_days = 30
}

# resource "aws_cloudwatch_log_stream" "crypto_api" {
#   name           = "${local.application.name}-log-stream"
#   log_group_name = aws_cloudwatch_log_group.crypto_api.name
# }