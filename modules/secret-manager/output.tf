output "rds_password_secret" {
  value = aws_secretsmanager_secret.lookcard_secrets["DB_MASTER_PASSWORD"].id
}

output "crypto_api_secret_arn" {
  value = aws_secretsmanager_secret.lookcard_secrets["CRYPTO_API_ENV"].arn
}

output "firebase_secret_arn" {
  value = aws_secretsmanager_secret.lookcard_secrets["FIREBASE"].arn
}

output "elliptic_secret_arn" {
  value = aws_secretsmanager_secret.lookcard_secrets["ELLIPTIC"].arn
}

output "database_secret_arn" {
  value = aws_secretsmanager_secret.lookcard_secrets["DATABASE"].arn
}

output "env_secret_arn" {
  value = aws_secretsmanager_secret.lookcard_secrets["ENV"].arn
}

output "token_secret_arn" {
  value = aws_secretsmanager_secret.lookcard_secrets["TOKEN"].arn
}

output "aml_env_secret_arn" {
  value = aws_secretsmanager_secret.lookcard_secrets["AML_ENV"].arn
}

output "trongrid_secret_arn" {
  value = aws_secretsmanager_secret.lookcard_secrets["TRONGRID"].arn
}
output "telegram_secret_arn" {
  value = aws_secretsmanager_secret.lookcard_secrets["TELEGRAM"].arn
}

output "system_crypto_wallet_secret_arn" {
  value = aws_secretsmanager_secret.lookcard_secrets["SYSTEM_CRYPTO_WALLET"].arn
}

output "coinranking_secret_arn" {
  value = aws_secretsmanager_secret.lookcard_secrets["COINRANKING"].arn
}

output "notification_env_secret_arn" {
  value = aws_secretsmanager_secret.lookcard_secrets["NOTIFICATION_ENV"].arn
}

output "sentry_secret_arn" {
  value = aws_secretsmanager_secret.lookcard_secrets["SENTRY"].arn
}