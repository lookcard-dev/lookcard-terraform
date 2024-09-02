resource "aws_service_discovery_service" "card_api_service" {
  name = "card.api"

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

resource "aws_ecs_service" "card_api" {
  name            = local.application.name
  task_definition = aws_ecs_task_definition.card_api.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  cluster         = var.cluster
  network_configuration {
    subnets          = var.network.private_subnet
    security_groups  = [aws_security_group.card_api.id]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.card_api_target_group.arn
    container_name   = local.application.name
    container_port   = local.application.port
  }

  service_registries {
    registry_arn = aws_service_discovery_service.card_api_service.arn
  }
}

resource "aws_lb_target_group" "card_api_target_group" {
  name        = "card"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.network.vpc
}


resource "aws_lb_listener_rule" "card_api_listener_rule" {
  listener_arn = var.default_listener

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.card_api_target_group.arn
  }
  condition {
    path_pattern {
      values = local.load_balancer.api_path # Wildcard path condition to match all requests
    }
  }
  priority = local.load_balancer.priority
  tags = {
    Name = "Card_api_listener_rule"
    # Add more tags as needed
  }
}
