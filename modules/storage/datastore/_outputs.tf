output "proxy_endpoint" {
  value = var.runtime_environment == "production" ? aws_db_proxy.this[0].endpoint : null
}

output "proxy_readonly_endpoint" {
  value = var.runtime_environment == "production" ? aws_db_proxy_endpoint.readonly[0].endpoint : null
}

output "proxy_arn" {
  value = var.runtime_environment == "production" ? aws_db_proxy.this[0].arn : null
}