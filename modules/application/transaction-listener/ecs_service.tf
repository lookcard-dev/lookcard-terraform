resource "aws_ecs_service" "transaction_listener" {
  name            = local.application.name
  task_definition = aws_ecs_task_definition.transaction_listener.arn
  # launch_type     = "FARGATE"
  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }
  desired_count = 1
  cluster       = var.cluster

  network_configuration {
    subnets         = [var.network.private_subnet[1]]
    security_groups = [aws_security_group.transaction_listener_sg.id]
  }
}


