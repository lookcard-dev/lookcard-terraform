resource "aws_lb_target_group" "webhook_api" {
  name        = "webhook-api-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.network.vpc_id
  target_type = "ip"

  health_check {
    path                = "/healthcheckz"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
}

resource "aws_lb_listener_rule" "webhook_api" {
  listener_arn = var.elb.core_application_load_balancer_http_listener_arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webhook_api.arn
  }

  condition {
    host_header {
      values = ["webhook.${var.general_domain}"]
    }
  }
}
