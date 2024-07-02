
resource "aws_service_discovery_service" "evvo_card_service" {
  name = "_card"

  dns_config {
    namespace_id = var.lookcardlocal_namespace_id

    dns_records {
      ttl  = 10
      type = "A"
    }
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_ecs_service" "Card" {
  name            = "Card"
  task_definition = aws_ecs_task_definition.Card.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  cluster         = var.cluster

  network_configuration {
    subnets          = [var.network.private_subnet[0], var.network.private_subnet[1], var.network.private_subnet[2]]
    security_groups  = [aws_security_group.Card.id]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.Card_target_group.arn
    container_name   = "Card"
    container_port   = "8000"
  }

  service_registries {
    registry_arn = aws_service_discovery_service.evvo_card_service.arn
  }
}

resource "aws_lb_target_group" "Card_target_group" {
  name        = "card"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.network.vpc
}


resource "aws_lb_listener_rule" "Card_listener_rule" {
  listener_arn = var.default_listener

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Card_target_group.arn
  }
  condition {
    path_pattern {
      values = ["/v2/api/card-ywso44nnn/*"] # Wildcard path condition to match all requests
    }
  }
  priority = 5
  tags = {
    Name = "Card_listener_rule"
    # Add more tags as needed
  }
}



resource "aws_security_group" "Card" {
  depends_on  = [var.network]
  name        = "Card-Service-Security-Group"
  description = "Security group for ECS services"
  vpc_id      = var.network.vpc

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Card-Security-Group"
  }
}



