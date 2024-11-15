resource "aws_ecs_service" "reap_webhook" {
  name            = local.application.name
  task_definition = aws_ecs_task_definition.reap_webhook.arn
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
}