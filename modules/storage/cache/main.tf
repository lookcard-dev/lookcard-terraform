resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "lookcard-redis-group"
  subnet_ids = var.network.database_subnet[*]
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id         = "lookcard-redis-cluster"
  engine             = "redis"
  node_type          = "cache.t4g.micro"
  num_cache_nodes    = 1
  port               = 6379
  security_group_ids = [aws_security_group.redis_sg.id]
  subnet_group_name  = aws_elasticache_subnet_group.redis_subnet_group.name

  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.elasticache_log.name
    destination_type = "cloudwatch-logs"
    log_format       = "json"
    log_type         = "slow-log"
  }
}
