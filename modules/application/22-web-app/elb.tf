resource "aws_lb_target_group" "service_target_group" {
  name        = "${var.name}-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.network.vpc_id
  target_type = "ip" # Required for Fargate

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 10 # Higher timeout for Next.js SSR
    interval            = 30
    path                = "/api/health" # Next.js health endpoint
    matcher             = "200"
  }

  # Deregistration delay for graceful shutdowns
  deregistration_delay = 30

  tags = {
    Name        = "${var.name}-target-group"
    Environment = var.runtime_environment
  }
}

resource "aws_lb_listener_rule" "web_app_listener_rule" {
  listener_arn = var.elb.application_load_balancer_http_listener_arn
  priority     = 5 # High priority for web application

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_target_group.arn
  }

  condition {
    host_header {
      values = ["app.${var.domain.general.name}"]
    }
  }

  tags = {
    Name        = "${var.name}-listener-rule"
    Environment = var.runtime_environment
  }
}
