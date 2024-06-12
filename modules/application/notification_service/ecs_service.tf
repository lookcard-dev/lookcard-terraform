
resource "aws_ecs_service" "Notification" {
  name            = "Notification"
  task_definition = aws_ecs_task_definition.Notification.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  cluster         = var.cluster

  network_configuration {
    subnets          = [var.network.private_subnet[0], var.network.private_subnet[1], var.network.private_subnet[2]] 
    security_groups  = [aws_security_group.Notification.id]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.Notification_target_group.arn
    container_name   = "Notification"
    container_port   = "3001"

  }
}

resource "aws_lb_target_group" "Notification_target_group" {
  name        = "Notification"
  port        = 80
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
      values = ["/v2/api/notify-eh1gwoj67/*"] # WildNotification path condition to match all requests
    }
  }
  priority = 4
  tags = {
    Name        = "Notification_listener_rule"
    # Add more tags as needed
  }
}

resource "aws_security_group" "Notification" {
  depends_on  = [var.network]
  name        = "Notification-Service-Security-Group"
  description = "Security group for ECS services"
  vpc_id      = var.network.vpc

  ingress {
    from_port       = 3001
    to_port         = 3001
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # security_groups = [aws_security_group.ALB_SG.id]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # security_groups = [aws_security_group.ALB_SG.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Notification-Serurity-Group"
  }
}
