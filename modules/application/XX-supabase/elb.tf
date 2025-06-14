resource "aws_lb_target_group" "kong" {
  name        = "supabase-kong-tg"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = var.network.vpc_id
  target_type = "ip"

  health_check {
    path                = "/status"
    port                = "8100"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = {
    Name        = "supabase-kong-tg"
    Environment = var.runtime_environment
  }
}

resource "aws_lb_listener_rule" "kong" {
  listener_arn = var.elb.application_load_balancer_http_listener_arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kong.arn
  }

  condition {
    host_header {
      values = ["supabase.${var.domain.general.name}"]
    }
  }

  tags = {
    Name        = "supabase-kong-rule"
    Environment = var.runtime_environment
  }
}
