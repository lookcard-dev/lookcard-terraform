resource "aws_service_discovery_service" "account_api_service" {
  name = "account.api"
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


resource "aws_ecs_service" "account_api" {
  name            = local.application.name
  task_definition = aws_ecs_task_definition.account_api.arn
  # launch_type     = "FARGATE"
  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }
  desired_count = 1
  cluster       = var.cluster

  network_configuration {
    subnets         = var.network.private_subnet
    security_groups = [aws_security_group.account_api_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.account_api_target_group.arn
    container_name   = local.application.name
    container_port   = local.application.port
  }

  service_registries {
    registry_arn = aws_service_discovery_service.account_api_service.arn
  }
}

resource "aws_lb_target_group" "account_api_target_group" {
  name        = local.application.name
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.network.vpc

  health_check {
    interval            = 30
    path                = "/healthcheckz"
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

resource "aws_lb_listener_rule" "account_api_listener_rule" {
  listener_arn = var.default_listener

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.account_api_target_group.arn
  }

  condition {
    path_pattern {
      values = local.load_balancer.api_path
    }
  }

  priority = 150
  tags = {
    Name = "${local.application.name}-rule"
  }
}
