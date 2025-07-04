# Target group for the ECS service
resource "aws_lb_target_group" "service_target_group" {
  name        = "${var.name}-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.network.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/healthcheckz"
    matcher             = "200"
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.name}-target-group"
  }
}

# Listener rule to route traffic to the target group
resource "aws_lb_listener_rule" "service_listener_rule" {
  listener_arn = var.elb.application_load_balancer_http_listener_arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_target_group.arn
  }

  condition {
    host_header {
      values = ["${replace(var.name, "-", ".")}.lookcard.local"]
    }
  }
}
