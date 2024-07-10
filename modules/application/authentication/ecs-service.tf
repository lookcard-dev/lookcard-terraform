
resource "aws_lb_listener_rule" "Authentication_listener_rule" {
  depends_on   = [var.vpc_id]
  listener_arn = var.aws_lb_listener_arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.authentication_tgp.arn
  }
  tags = {
    Name = "${local.application.name}-rule"
  }
  condition {
    path_pattern {
      values = local.load_balancer.api_path
    }
  }
}

resource "aws_lb_target_group" "authentication_tgp" {
  depends_on  = [var.network]
  name        = local.application.name
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.network.vpc

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
  name            = local.application.name
  task_definition = aws_ecs_task_definition.Authentication.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  cluster         = var.cluster
  network_configuration {
    subnets         = var.network.private_subnet
    security_groups = [aws_security_group.Authentication.id]                                                        # Replace with your security group ID
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.authentication_tgp.arn
    container_name   = local.application.name
    container_port   = local.application.port
  }
}

# resource "aws_appautoscaling_policy" "Authentication" {
#   name               = "Authentication"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.Authentication.resource_id
#   scalable_dimension = aws_appautoscaling_target.Authentication.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.Authentication.service_namespace
#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageCPUUtilization"
#     }
#     target_value       = 50 # Adjust this value as needed
#     scale_out_cooldown = 60
#     scale_in_cooldown  = 180
#   }

# }

# # Define autoscaling target
# resource "aws_appautoscaling_target" "Authentication" {
#   max_capacity       = 30 # Adjust this value as needed
#   min_capacity       = 6
#   resource_id        = "service/${var.cluster_name}/${aws_ecs_service.Authentication.name}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   service_namespace  = "ecs"

# }

#
