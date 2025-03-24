data "aws_route53_zone" "zone" {
  name = "lookcard.local"
}

data "aws_lb" "alb" {
  arn = var.elb.core_application_load_balancer_arn
}

resource "aws_lb_target_group" "alb_target_group" {
  name        = "${var.name}-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.network.vpc_id
  target_type = "ip"
  slow_start  = 30
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

resource "aws_lb_listener_rule" "alb_listener_rule" {
  listener_arn = var.elb.core_application_load_balancer_http_listener_arn
  priority     = 00
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
  condition {
    host_header {
      values = ["${replace(var.name, "-", ".")}.lookcard.local"]
    }
  }
}

resource "aws_route53_record" "alb" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "${replace(var.name, "-", ".")}.lookcard.local"
  type    = "A"
  alias {
    name                   = data.aws_lb.alb.dns_name
    zone_id                = data.aws_lb.alb.zone_id
    evaluate_target_health = false
  }
}
