output "secret_arns" {
  value = { for s in aws_secretsmanager_secret.secret : s.name => s.arn }
}

output "secret_ids" {
  value = { for s in aws_secretsmanager_secret.secret : s.name => s.id }
}