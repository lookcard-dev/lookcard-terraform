resource "aws_service_discovery_service" "user_api_service" {
  name = "user.api"
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

resource "aws_ecs_service" "user_api_ecs_service" {
  name            = local.application.name
  task_definition = aws_ecs_task_definition.user_api_task_definition.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  cluster         = var.cluster
  network_configuration {
    subnets         = var.network.private_subnet
    security_groups = [aws_security_group.user_api_security_grp.id]
  }
  service_registries {
    registry_arn = aws_service_discovery_service.user_api_service.arn
  }
}
