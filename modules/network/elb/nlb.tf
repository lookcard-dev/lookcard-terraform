resource "aws_lb" "network_load_balancer" {
  name               = "nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.network_load_balancer_security_group.id]
}

resource "aws_lb_target_group" "network_load_balancer_http_target_group" {
  name        = "nlb-http-target"
  port        = 80
  target_type = "alb"
  protocol    = "TCP"
  vpc_id      = var.vpc_id
}

resource "aws_lb_target_group" "network_load_balancer_https_target_group" {
  count       = var.certificate_arns != null && length(var.certificate_arns) > 0 ? 1 : 0
  name        = "nlb-https-target"
  port        = 443
  target_type = "alb"
  protocol    = "TCP"
  vpc_id      = var.vpc_id
}

resource "aws_lb_target_group_attachment" "network_load_balancer_http_target_group_attachment" {
  depends_on = [
    aws_lb_listener.network_load_balancer_http_listener,
    aws_lb_listener.application_load_balancer_http_listener,
    aws_lb_target_group.network_load_balancer_http_target_group
  ]
  target_group_arn = aws_lb_target_group.network_load_balancer_http_target_group.arn
  target_id        = aws_lb.application_load_balancer.arn
  port             = 80
}

resource "aws_lb_target_group_attachment" "network_load_balancer_https_target_group_attachment" {
  count = var.certificate_arns != null && length(var.certificate_arns) > 0 ? 1 : 0
  depends_on = [
    aws_lb_listener.network_load_balancer_https_listener,
    aws_lb_listener.application_load_balancer_https_listener,
    aws_lb_target_group.network_load_balancer_https_target_group
  ]
  target_group_arn = aws_lb_target_group.network_load_balancer_https_target_group[0].arn
  target_id        = aws_lb.application_load_balancer.arn
  port             = 443
}

# Create NLB Listener
resource "aws_lb_listener" "network_load_balancer_http_listener" {
  depends_on = [
    aws_lb_target_group.network_load_balancer_http_target_group
  ]
  load_balancer_arn = aws_lb.network_load_balancer.arn
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.network_load_balancer_http_target_group.arn
  }
}

resource "aws_lb_listener" "network_load_balancer_https_listener" {
  count = var.certificate_arns != null && length(var.certificate_arns) > 0 ? 1 : 0
  depends_on = [
    aws_lb_target_group.network_load_balancer_https_target_group
  ]
  load_balancer_arn = aws_lb.network_load_balancer.arn
  port              = "443"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.network_load_balancer_https_target_group[0].arn
  }
}