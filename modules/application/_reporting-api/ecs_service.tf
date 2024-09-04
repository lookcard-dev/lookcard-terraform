resource "aws_lb_target_group" "reporting_api_target_group" {
  name        = local.application.name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.network.vpc
  target_type = "ip"
}

resource "aws_lb_listener_rule" "reporting_api_listener_rule" {
  listener_arn = var.default_listener

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.reporting_api_target_group.arn
  }

  condition {
    path_pattern {
      values = local.load_balancer.api_path # Wildcard path to match all requests to the reporting service
    }
  }

  priority = local.load_balancer.priority
  tags = {
    Name = "${local.application.name}-listener-rule"
  }
}

resource "aws_ecs_service" "reporting_api" {
  name            = local.application.name
  task_definition = aws_ecs_task_definition.reporting_api.arn
  # launch_type     = "FARGATE"
  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }
  desired_count = 1
  cluster       = var.cluster

  network_configuration {
    subnets         = var.network.private_subnet
    security_groups = [aws_security_group.reporting.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.reporting_api_target_group.arn
    container_name   = local.application.name
    container_port   = local.application.port
  }
}



