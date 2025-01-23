output "endpoint" {
  value = aws_elasticache_replication_group.cluster.primary_endpoint_address
}