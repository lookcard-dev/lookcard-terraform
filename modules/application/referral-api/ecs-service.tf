
resource "aws_service_discovery_service" "referral_api_service" {
  name = "referral.api"

  dns_config {
    namespace_id = var.lookcardlocal_namespace

    dns_records {
      ttl  = 10
      type = "A"
    }
  }
  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_ecs_service" "referral_api" {
  name            = local.application.name
  task_definition = aws_ecs_task_definition.profile-api.arn
  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }
  desired_count = 1
  cluster       = var.cluster

  network_configuration {
    subnets         = var.network.private_subnet
    security_groups = [aws_security_group.profile-api-sg.id]
  }

  service_registries {
    registry_arn = aws_service_discovery_service.referral_api_service.arn
  }
}
