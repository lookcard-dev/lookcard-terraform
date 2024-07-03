resource "aws_ecs_service" "Transaction_Listener_Service_1" {
  name            = "Transaction-Listener-1"
  task_definition = aws_ecs_task_definition.Transaction-Listener-1.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  cluster         = var.cluster

  network_configuration {
    subnets         = [var.network.private_subnet[1]]
    security_groups = [aws_security_group.Transaction-Listener-SG.id]
  }
}


