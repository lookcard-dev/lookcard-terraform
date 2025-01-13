resource "aws_service_discovery_service" "edns_api_service" {
  name = "edns.api"
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


resource "aws_ecs_service" "edns_api" {
  name            = local.application.name
  task_definition = aws_ecs_task_definition.edns_api.arn
  # launch_type     = "FARGATE"
  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }
  desired_count = 1
  cluster       = var.cluster

  network_configuration {
    subnets         = var.network.private_subnet
    security_groups = [aws_security_group.edns_api_ecs_svc_sg.id]
  }
  service_registries {
    registry_arn = aws_service_discovery_service.edns_api_service.arn
  }
}

