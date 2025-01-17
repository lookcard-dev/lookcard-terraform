resource "aws_elasticache_subnet_group" "subnet_group" {
  name       = "datacache-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_replication_group" "cluster" {
  replication_group_id = "datacache"
  description         = "Datacache - Redis Cluster"

  node_type = "cache.t4g.micro"  

  multi_az_enabled = contains(["staging", "production"], var.runtime_environment)
  automatic_failover_enabled = contains(["staging", "production"], var.runtime_environment)
  
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  
  num_cache_clusters = lookup({
    develop    = 1
    testing    = 1
    staging    = 2  # primary + 1 replica
    production = 3  # primary + 2 replicas
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
