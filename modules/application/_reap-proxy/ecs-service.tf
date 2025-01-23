resource "aws_ecs_service" "reap_proxy" {
  name            = local.application.name
  task_definition = aws_ecs_task_definition.reap_proxy.arn
  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }
  desired_count = 1
  cluster       = var.cluster

  network_configuration {
    subnets         = var.network.private_subnet
    security_groups = [aws_security_group.reap_proxy_ecs_svc_sg.id]
  }

#   service_registries {
#     registry_arn = aws_service_discovery_service.referral_api_service.arn
#   }
}
