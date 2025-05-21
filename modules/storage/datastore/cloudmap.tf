resource "aws_service_discovery_service" "master" {
  name = "rw.datastore"

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
    AWS_INSTANCE_CNAME = var.runtime_environment == "production" ? aws_db_proxy.this[0].endpoint : aws_rds_cluster.cluster.endpoint
  }
}

resource "aws_service_discovery_service" "replica" {
  name = "ro.datastore"

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

resource "aws_service_discovery_instance" "replica" {
  instance_id = "replica"
  service_id  = aws_service_discovery_service.replica.id
  attributes = {
    AWS_INSTANCE_CNAME = var.runtime_environment == "production" ? aws_db_proxy_endpoint.readonly[0].endpoint : aws_rds_cluster.cluster.reader_endpoint
  }
}
