
resource "aws_service_discovery_service" "discovery_service" {
  name = replace(var.application_name, "-", ".")

  dns_config {
    namespace_id = var.namespace_id
    dns_records {
      ttl  = 10
      type = "A"
    }
  }
  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_ecs_service" "ecs_service" {
  name            = var.application_name
  task_definition = aws_ecs_task_definition.task_definition.arn
  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }
  desired_count = 1
  cluster       = var.cluster_arn

  network_configuration {
    subnets         = var.network.private_subnet
    security_groups = [aws_security_group.security_group.id]
  }

  service_registries {
    registry_arn = aws_service_discovery_service.discovery_service.arn
  }
}