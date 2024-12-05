resource "aws_lb_target_group" "reseller_api_target_group" {
  name        = local.application.name
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.network.vpc
  health_check {
    interval            = 30
    path                = "/healthcheckz"
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}


resource "aws_lb_listener_rule" "reseller_api_rule" {
  listener_arn = var.default_listener

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.reseller_api_target_group.arn
  }

  condition {
    host_header {
      values = ["api.reseller.develop.not-lookcard.com"]# local.load_balancer.api_path
    }
  }

  priority = local.load_balancer.priority
  tags = {
    Name = "reseller-api-rule"
  }
}