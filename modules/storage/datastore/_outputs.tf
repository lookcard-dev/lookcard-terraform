output "writer_endpoint" {
  # value = var.runtime_environment == "production" ? aws_db_proxy.this[0].endpoint : aws_rds_cluster.cluster.endpoint
  value = aws_rds_cluster.cluster.endpoint

}

output "reader_endpoint" {
  # value = var.runtime_environment == "production" ? aws_db_proxy_endpoint.readonly[0].endpoint : aws_rds_cluster.cluster.reader_endpoint
  value = aws_rds_cluster.cluster.reader_endpoint
}

output "cluster_security_group_id" {
  value = aws_security_group.cluster_security_group.id
}

output "proxy_security_group_id" {
  value = aws_security_group.proxy_security_group.id
}
