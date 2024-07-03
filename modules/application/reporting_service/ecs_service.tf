
resource "aws_lb_listener_rule" "reporting_listener_rule" {
  listener_arn = var.default_listener

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.reporting_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/v2/api/report-zjx14peaj/*"] # Wildcard path to match all requests to the reporting service
    }
  }

  priority = 6
  tags = {
    Name        = "Reporting-listener-rule"
    Environment = "UAT"
  }
}

resource "aws_lb_target_group" "reporting_target_group" {
  name        = "Reporting"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.network.vpc
  target_type = "ip"
}

resource "aws_ecs_service" "reporting" {
  name            = "Reporting"
  task_definition = aws_ecs_task_definition.Reporting.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  cluster         = var.cluster

  network_configuration {
    subnets         = [var.network.private_subnet[0], var.network.private_subnet[1], var.network.private_subnet[2]]
    security_groups = [aws_security_group.Reporting.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.reporting_target_group.arn
    container_name   = "Reporting"
    container_port   = 8000
  }
}



