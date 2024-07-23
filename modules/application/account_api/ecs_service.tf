resource "aws_service_discovery_service" "account_service" {
  name = "account"

  dns_config {
    namespace_id = var.api_lookcardlocal_namespace

    dns_records {
      ttl  = 10
      type = "A"
    }
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_ecs_service" "Account_API" {
  name            = local.application.name
  task_definition = aws_ecs_task_definition.Account_API.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  cluster         = var.cluster

  network_configuration {
    subnets         = var.network.private_subnet
    security_groups = [aws_security_group.Account-API-SG.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.Account_API_target_group.arn
    container_name   = local.application.name
    container_port   = local.application.port
  }

  service_registries {
    registry_arn = aws_service_discovery_service.account_service.arn
  }
}

resource "aws_lb_target_group" "Account_API_target_group" {
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

resource "aws_lb_listener_rule" "Account_API_listener_rule" {
  listener_arn = var.default_listener

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Account_API_target_group.arn
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
