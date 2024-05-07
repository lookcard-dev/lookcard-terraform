output "secret_arns" {
  value       = { for s in aws_secretsmanager_secret.lookcard_secrets : s.name => s.arn }
  description = "The ARNs of the secrets managed by AWS Secrets Manager"
}
