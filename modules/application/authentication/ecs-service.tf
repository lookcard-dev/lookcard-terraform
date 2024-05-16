
resource "aws_lb_listener" "look-card" {
  depends_on        = [var.ssl]
  load_balancer_arn = var.alb
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Authentication_TGP.arn
  }
  port            = 443
  protocol        = "HTTPS"
  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.ssl
}

resource "aws_lb_listener_rule" "Authentication_listener_rule" {
  depends_on   = [var.vpc]
  listener_arn = aws_lb_listener.look-card.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Authentication_TGP.arn
  }
  condition {
    path_pattern {
      values = ["/v2/api/auth-zqg2muwph/*"]
    }
  }
}

resource "aws_lb_target_group" "Authentication_TGP" {
  depends_on  = [var.vpc]
  name        = "Authentication-${var.env}"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
}

resource "aws_ecs_service" "Authentication" {
  name            = "Authentication"
  task_definition = aws_ecs_task_definition.Authentication.arn
  launch_type     = "FARGATE"
  desired_count   = 3
  cluster         = var.cluster

  network_configuration {

    subnets         = [var.Private-Subnet-1[0], var.Private-Subnet-2[1], var.Private-Subnet-2[2]] # Replace with your subnet IDs
    security_groups = [var.ecs_security_groups]                                                   # Replace with your security group ID
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.Authentication_TGP.arn
    container_name   = "Authentication"
    container_port   = "8000"
  }
}

resource "aws_appautoscaling_policy" "Authentication" {
  name               = "Authentication"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.Authentication.resource_id
  scalable_dimension = aws_appautoscaling_target.Authentication.scalable_dimension
  service_namespace  = aws_appautoscaling_target.Authentication.service_namespace
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 50 # Adjust this value as needed
    scale_out_cooldown = 60
    scale_in_cooldown  = 180
  }

}

# Define autoscaling target
resource "aws_appautoscaling_target" "Authentication" {
  max_capacity       = 30 # Adjust this value as needed
  min_capacity       = 6
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.Authentication.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

}