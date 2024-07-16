resource "aws_elasticache_serverless_cache" "redis" {
  engine = "redis"
  name   = "redis"
  major_engine_version     = "7"
  security_group_ids       = [aws_security_group.redis_sg.id]
  subnet_ids               = var.network.database_subnet[*]
}


