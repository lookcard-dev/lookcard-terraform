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
  name        = "nlb-https-target"
  port        = 443
  target_type = "alb"
  protocol    = "TCP"
  vpc_id      = var.vpc_id
}

resource "aws_lb_target_group_attachment" "network_load_balancer_http_target_group_attachment" {
  depends_on = [
    aws_lb_listener.network_load_balancer_http_listener
  ]
  target_group_arn = aws_lb_target_group.network_load_balancer_http_target_group.arn
  target_id        = aws_lb.application_load_balancer.arn
  port             = 80
}

resource "aws_lb_target_group_attachment" "network_load_balancer_https_target_group_attachment" {
  depends_on = [
    aws_lb_listener.network_load_balancer_https_listener,
    aws_lb_listener.application_load_balancer_https_listener
  ]
  target_group_arn = aws_lb_target_group.network_load_balancer_https_target_group.arn
  target_id        = aws_lb.application_load_balancer.arn
  port             = 443
}

# Create NLB Listener
resource "aws_lb_listener" "network_load_balancer_http_listener" {
  load_balancer_arn = aws_lb.network_load_balancer.arn
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.network_load_balancer_http_target_group.arn
  }
}

resource "aws_lb_listener" "network_load_balancer_https_listener" {
  load_balancer_arn = aws_lb.network_load_balancer.arn
  port              = "443"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.network_load_balancer_https_target_group.arn
  }
}

resource "aws_lb_listener" "application_load_balancer_http_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.application_load_balancer_http_target_group.arn
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "application_load_balancer_https_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 443
  protocol          = "HTTPS"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = var.certificate_arn  # Make sure to add this variable

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.application_load_balancer_https_target_group.arn
  }

  lifecycle {
    create_before_destroy = true
  }
}