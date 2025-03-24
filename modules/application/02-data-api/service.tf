resource "aws_ecs_service" "ecs_service" {
  name            = var.name
  task_definition = aws_ecs_task_definition.task_definition.arn
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }
  capacity_provider_strategy {
    capacity_provider = var.runtime_environment == "production" ? "FARGATE" : "FARGATE_SPOT"
    weight            = 1
  }

  desired_count = var.image_tag == "latest" ? 0 : (var.runtime_environment == "production" ? 2 : 1)
  cluster       = var.cluster_id

  network_configuration {
    subnets         = var.network.private_subnet_ids
    security_groups = [aws_security_group.security_group.id]
  }
}
