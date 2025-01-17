output "proxy_endpoint" {
  value       = aws_db_proxy.this.endpoint
}

output "proxy_readonly_endpoint" {
  value       = aws_db_proxy_endpoint.readonly.endpoint
}

output "proxy_arn" {
  value       = aws_db_proxy.this.arn
}