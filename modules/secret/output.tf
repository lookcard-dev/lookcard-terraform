output "rds_password_secret" {
  value = aws_secretsmanager_secret.lookcard_secrets["DB_MASTER_PASSWORD"].id
}

output "sendgrid_secret" {
  value = aws_secretsmanager_secret.lookcard_secrets["SENDGRID"].arn
}
output "rds_password_arn_secret" {
  value = aws_secretsmanager_secret.lookcard_secrets["DB_MASTER_PASSWORD"].arn
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
output "database_secret_id" {
  value = aws_secretsmanager_secret.lookcard_secrets["DATABASE"].id
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

output "get_block_secret_arn" {
  value = aws_secretsmanager_secret.lookcard_secrets["GET_BLOCK"].arn
}

# loop arns
output "secret_arns" {
  value       = { for s in aws_secretsmanager_secret.lookcard_secrets : s.name => s.arn }
  description = "The ARNs of the secrets managed by AWS Secrets Manager"
}

# loop ids
output "secret_ids" {
  value       = { for s in aws_secretsmanager_secret.lookcard_secrets : s.name => s.id }
  description = "The ARNs of the secrets managed by AWS Secrets Manager"
}