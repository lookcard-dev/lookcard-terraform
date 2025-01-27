output "writer_endpoint" {
  value = var.runtime_environment == "production" ? aws_db_proxy.this[0].endpoint : aws_rds_cluster.cluster.endpoint
}

output "reader_endpoint" {
  value = var.runtime_environment == "production" ? aws_db_proxy_endpoint.readonly[0].endpoint : aws_rds_cluster.cluster.reader_endpoint
}