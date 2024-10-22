
resource "aws_ecs_service" "notification_v2" {
  name            = local.application.name
  task_definition = aws_ecs_task_definition.notification_v2.arn
  # launch_type     = "FARGATE"
  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }
  desired_count = 1
  cluster       = var.cluster
  network_configuration {
    subnets          = var.network.private_subnet
    security_groups  = [aws_security_group.notification_v2.id]
    assign_public_ip = false
  }
  # load_balancer {
  #   target_group_arn = aws_lb_target_group.notification_v2_target_group.arn
  #   container_name   = local.application.name
  #   container_port   = local.application.port
  # }
}

# resource "aws_lb_target_group" "notification_v2_target_group" {
#   name        = local.application.name
#   port        = 80
#   protocol    = "HTTP"
#   target_type = "ip"
#   vpc_id      = var.network.vpc
#   health_check {
#     interval            = 30
#     path                = "/healthcheckz"
#     timeout             = 10
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     matcher             = "200-399"
#   }
# }

# resource "aws_lb_listener_rule" "notification_v2_listener_rule" {
#   listener_arn = var.default_listener

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.notification_v2_target_group.arn
#   }
#   condition {
#     path_pattern {
#       values = local.load_balancer.api_path
#     }
#   }
#   priority = local.load_balancer.priority
#   tags = {
#     Name = "${local.application.name}_listener_rule"
#   }
# }
