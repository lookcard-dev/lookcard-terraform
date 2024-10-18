output "redis_host" {
  value = aws_elasticache_cluster.redis.configuration_endpoint
}