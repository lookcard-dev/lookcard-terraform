resource "aws_elasticache_serverless_cache" "cluster" {
  name                 = "datacache"
  engine               = "valkey"
  major_engine_version = "7"

  subnet_ids         = var.subnet_ids
  security_group_ids = [aws_security_group.cluster_security_group.id]

  cache_usage_limits {
    data_storage {
      maximum = var.runtime_environment == "production" ? 10 : 1
      unit    = "GB"
    }
    ecpu_per_second {
      maximum = var.runtime_environment == "production" ? 5000 : 1000
    }
  }
  tags = {
    Environment = var.runtime_environment
  }
}