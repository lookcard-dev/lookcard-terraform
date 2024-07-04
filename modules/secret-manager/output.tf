output "lookcard_db_secret" {
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
