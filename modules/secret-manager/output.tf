output "secret_arns" {
  value       = toset([for s in aws_secretsmanager_secret.lookcard_secrets : s.arn])
  description = "The ARNs of the secrets managed by AWS Secrets Manager"
}


output "lookcard_db_secret" {
  value = aws_secretsmanager_secret.lookcard_secrets["look-card_db_master_password"].id
}

output "crypto_api_secret_arn" {
  value = aws_secretsmanager_secret_version.crypto_api_env_secret_value.arn
}

output "firebase_secret_arn" {
  value = aws_secretsmanager_secret_version.firebase_secret_value.arn
}

output "elliptic_secret_arn" {
  value = aws_secretsmanager_secret_version.elliptic_secret_value.arn
}

output "db_secret_secret_arn" {
  value = aws_secretsmanager_secret_version.db_secret_value.arn
}