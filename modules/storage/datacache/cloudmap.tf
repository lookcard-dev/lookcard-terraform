resource "aws_service_discovery_service" "master" {
  name = "datacache"

  dns_config {
    dns_records {
      type = "CNAME"
      ttl  = 10
    }
    namespace_id   = var.namespace_id
    routing_policy = "WEIGHTED"
  }
  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_instance" "master" {
  instance_id = "master"
  service_id  = aws_service_discovery_service.master.id
  attributes = {
    AWS_INSTANCE_CNAME = aws_elasticache_serverless_cache.cluster.endpoint[0].address
  }
}
