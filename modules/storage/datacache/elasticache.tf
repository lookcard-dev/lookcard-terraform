resource "aws_elasticache_subnet_group" "subnet_group" {
  name       = "datacache-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_replication_group" "cluster" {
  replication_group_id = "datacache"
  description         = "Datacache - Redis Cluster"
  node_type = "cache.t4g.micro"  
  engine = "redis"
  engine_version = "6.x"

  multi_az_enabled = var.runtime_environment == "production"
  automatic_failover_enabled = var.runtime_environment == "production"
  
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  
  num_cache_clusters = lookup({
    develop    = 1
    testing    = 1
    staging    = 1  # primary + 1 replica
    production = 2  # primary + 1 replica
  }, var.runtime_environment, 1)

  # cluster_enabled = false

  port               = 6379
  security_group_ids = [aws_security_group.cluster_security_group.id]
  subnet_group_name  = aws_elasticache_subnet_group.subnet_group.name

  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.log.name
    destination_type = "cloudwatch-logs"
    log_format      = "json"
    log_type        = "slow-log"
  }

  tags = {
    Environment = var.runtime_environment
  }
}

# resource "aws_elasticache_serverless_cache" "cluster" {
#   name = "datacache"
#   engine = "valkey"
#   major_engine_version = "8"

#   subnet_ids = var.subnet_ids
#   security_group_ids = [aws_security_group.cluster_security_group.id]

#   cache_usage_limits {
#     data_storage {
#         maximum = var.runtime_environment == "production" ? 10 : 1
#         unit = "GB"
#     }
#     ecpu_per_second {
#       maximum = var.runtime_environment == "production" ? 5000 : 1000
#     }
#   }
#   tags = {
#     Environment = var.runtime_environment
#   }
# }