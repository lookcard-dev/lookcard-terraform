resource "aws_service_discovery_service" "evvo_user_service" {
  name = "_user"

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

resource "aws_ecs_service" "users" {
  name            = "Users"
  task_definition = aws_ecs_task_definition.Users.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  cluster         = var.cluster

  network_configuration {
    subnets          = [var.network.private_subnet[0], var.network.private_subnet[1], var.network.private_subnet[2]] 
    security_groups = [aws_security_group.Users.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.users_target_group.arn
    container_name   = "Users"
    container_port   = 8000
  }

  service_registries {
    registry_arn   = aws_service_discovery_service.evvo_user_service.arn
  }
}


resource "aws_lb_target_group" "users_target_group" {
  name        = "Users"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.network.vpc
  target_type = "ip"
}

resource "aws_lb_listener_rule" "users_listener_rule" {
  listener_arn = var.default_listener

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.users_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/v2/api/us-f8zjng13d/*"]
    }
  }

  priority = 8
  tags = {
    Name        = "Users-listener-rule"
    Environment = "UAT"
  }
}


resource "aws_security_group" "Users" {
  depends_on  = [var.network]
  name        = "Users-Service-Security-Group"
  description = "Security group for ECS services"
  vpc_id      = var.network.vpc

  ingress {
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # security_groups = [aws_security_group.ALB_SG.id, aws_security_group.Account-API-SG.id, aws_security_group.Lambda_Aggregator_Tron_SG.id]
  }


  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # security_groups = [aws_security_group.ALB_SG.id, aws_security_group.Account-API-SG.id, aws_security_group.Lambda_Aggregator_Tron_SG.id]
  }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Users-Security-Group"
  }
}
