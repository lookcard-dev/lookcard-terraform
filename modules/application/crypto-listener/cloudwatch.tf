resource "aws_cloudwatch_log_group" "ecs_log_crypto_listener_trongrid" {
  name = "/ecs/${local.nile-trongrid.name}"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "application_log_crypto_listener_trongrid" {
  name = "/lookcard/crypto-listener/tron/nile/trongrid"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "ecs_log_crypto_listener_nile" {
  name = "/ecs/${local.nile-getblock.name}"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "application_log_crypto_listener_getblock" {
  name = "/lookcard/crypto-listener/tron/nile/getblock"
  retention_in_days = 30
}