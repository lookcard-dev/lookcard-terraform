resource "aws_service_discovery_service" "discovery_service" {
  name = replace(var.name, "-", ".")
  dns_config {
    namespace_id = var.namespace_id
    dns_records {
      ttl  = 10
      type = "A"
    }
  }
}

resource "aws_ecs_service" "ecs_service" {
  name            = var.name
  task_definition = aws_ecs_task_definition.task_definition.arn
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }
  

  desired_count = var.image_tag == "latest" ? 0 : (
    var.runtime_environment == "production" ? 2 : 1
  )
  cluster = var.cluster_id

  network_configuration {
    subnets         = var.network.private_subnet_ids
    security_groups = [aws_security_group.security_group.id]
  }

  service_registries {
    registry_arn = aws_service_discovery_service.discovery_service.arn
  }
  lifecycle {
    ignore_changes = [
      capacity_provider_strategy
    ]
  }
}
