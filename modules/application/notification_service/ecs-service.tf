
resource "aws_ecs_service" "Notification" {
  name            = local.application.name
  task_definition = aws_ecs_task_definition.Notification.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  cluster         = var.cluster

  network_configuration {
    subnets          = var.network.private_subnet
    security_groups  = [aws_security_group.Notification.id]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.Notification_target_group.arn
    container_name   = local.application.name
    container_port   = local.application.port

  }
}

resource "aws_lb_target_group" "Notification_target_group" {
  name        = local.application.name
  port        = local.application.port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.network.vpc
}


resource "aws_lb_listener_rule" "Notification_listener_rule" {
  listener_arn = var.default_listener

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Notification_target_group.arn
  }
  condition {
    path_pattern {
      values = local.load_balancer.api_path
    }
  }
  priority = local.load_balancer.priority
  tags = {
    Name = "${local.application.name}_listener_rule"

  }
}
