resource "aws_secretsmanager_secret" "lookcard_secrets" {
  for_each    = toset(var.secret_names)
  name        = each.value
  description = "Secret for ${each.value}"

  lifecycle {
    prevent_destroy = false
  }
}

# resource "aws_secretsmanager_secret_version" "env_secret_value" {
#   secret_id = aws_secretsmanager_secret.lookcard_secrets["env"].id

#   secret_string = jsonencode(var.env_secrets)

#   depends_on = [aws_secretsmanager_secret.lookcard_secrets]
# }

# resource "aws_secretsmanager_secret_version" "notification_env_secret_value" {
#   secret_id = aws_secretsmanager_secret.lookcard_secrets["notification-env"].id

#   secret_string = jsonencode(var.notification_env_secrets)

#   depends_on = [aws_secretsmanager_secret.lookcard_secrets]
# }

# resource "aws_secretsmanager_secret_version" "tron_secret_value" {
#   secret_id = aws_secretsmanager_secret.lookcard_secrets["tron"].id

#   secret_string = jsonencode(var.tron_secrets)

#   depends_on = [aws_secretsmanager_secret.lookcard_secrets]
# }

# resource "aws_secretsmanager_secret_version" "coinranking_secret_value" {
#   secret_id = aws_secretsmanager_secret.lookcard_secrets["coinranking"].id

#   secret_string = jsonencode(var.coinranking_secrets)

#   depends_on = [aws_secretsmanager_secret.lookcard_secrets]
# }

# resource "aws_secretsmanager_secret_version" "crypto_api_worker_wallet_secret_value" {
#   secret_id = aws_secretsmanager_secret.lookcard_secrets["crypto-api-worker-wallet"].id

#   secret_string = jsonencode(var.crypto_api_worker_wallet_secrets)

#   depends_on = [aws_secretsmanager_secret.lookcard_secrets]
# }

# resource "aws_secretsmanager_secret_version" "elliptic_secret_value" {
#   secret_id = aws_secretsmanager_secret.lookcard_secrets["elliptic"].id

#   secret_string = jsonencode(var.elliptic_secrets)

#   depends_on = [aws_secretsmanager_secret.lookcard_secrets]
# }

# resource "aws_secretsmanager_secret_version" "reap_secret_value" {
#   secret_id = aws_secretsmanager_secret.lookcard_secrets["reap"].id

#   secret_string = jsonencode(var.reap_secrets)

#   depends_on = [aws_secretsmanager_secret.lookcard_secrets]
# }

# resource "aws_secretsmanager_secret_version" "did_processor_lambda_secret_value" {
#   secret_id = aws_secretsmanager_secret.lookcard_secrets["did-processor/lambda"].id

#   secret_string = jsonencode(var.did_processor_lambda_secrets)

#   depends_on = [aws_secretsmanager_secret.lookcard_secrets]
# }

# resource "aws_secretsmanager_secret_version" "token_secret_value" {
#   secret_id = aws_secretsmanager_secret.lookcard_secrets["token"].id

#   secret_string = jsonencode(var.token_secrets)

#   depends_on = [aws_secretsmanager_secret.lookcard_secrets]
# }

# resource "aws_secretsmanager_secret_version" "aggregator_env_secret_value" {
#   secret_id = aws_secretsmanager_secret.lookcard_secrets["aggregator-env"].id

#   secret_string = jsonencode(var.aggregator_env_secrets)

#   depends_on = [aws_secretsmanager_secret.lookcard_secrets]
# }

# resource "aws_secretsmanager_secret_version" "db_secret_value" {
#   secret_id = aws_secretsmanager_secret.lookcard_secrets["db/secret"].id

#   secret_string = jsonencode(var.db_secrets)

#   depends_on = [aws_secretsmanager_secret.lookcard_secrets]

# }

# resource "aws_secretsmanager_secret_version" "firebase_secret_value" {
#   secret_id = aws_secretsmanager_secret.lookcard_secrets["firebase"].id

#   secret_string = jsonencode(var.firebase_secrets)

#   depends_on = [aws_secretsmanager_secret.lookcard_secrets]
# }

# resource "aws_secretsmanager_secret_version" "crypto_api_env_secret_value" {
#   secret_id = aws_secretsmanager_secret.lookcard_secrets["crypto-api-env"].id

#   secret_string = jsonencode(var.crypto_api_env_secrets)

#   depends_on = [aws_secretsmanager_secret.lookcard_secrets]
# }

# resource "aws_secretsmanager_secret_version" "aml_env_secret_value" {
#   secret_id = aws_secretsmanager_secret.lookcard_secrets["aml_env"].id

#   secret_string = jsonencode(var.aml_env_secrets)

#   depends_on = [aws_secretsmanager_secret.lookcard_secrets]
# }

