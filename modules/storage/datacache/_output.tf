output "endpoint" {
  value = aws_elasticache_serverless_cache.cluster.endpoint[0].address
}

output "security_group_id" {
  value = aws_security_group.cluster_security_group.id
}