output "secret_arns" {
  value       = toset([for s in aws_secretsmanager_secret.lookcard_secrets : s.arn])
  description = "The ARNs of the secrets managed by AWS Secrets Manager"
}
