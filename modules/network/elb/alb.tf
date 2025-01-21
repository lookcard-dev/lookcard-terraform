data "aws_s3_bucket" "logs_bucket" {
  count  = 1
  bucket = "${var.aws_provider.account_id}-log"
}

resource "aws_lb" "application_load_balancer" {
  name               = "alb"
  internal           = true
  load_balancer_type = "application"
  subnets            = var.subnet_ids

  security_groups    = [aws_security_group.application_load_balancer_security_group.id]

  enable_deletion_protection = var.runtime_environment == "production" ? true : false
  preserve_host_header       = true
  drop_invalid_header_fields = true

  access_logs {
    enabled = can(data.aws_s3_bucket.logs_bucket[0]) ? true : false
    bucket  = "${var.aws_provider.account_id}-log"
    prefix  = "ELB/access_logs"
  }
  connection_logs {
    enabled = can(data.aws_s3_bucket.logs_bucket[0]) ? true : false
    bucket  = "${var.aws_provider.account_id}-log"
    prefix  = "ELB/connection_logs"
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
}

resource "aws_lb_listener" "application_load_balancer_https_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 443
  protocol          = "HTTPS"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.application_load_balancer_https_target_group.arn
  }
}



resource "aws_lb_target_group" "application_load_balancer_https_target_group" {
  name        = "alb-https-tg"
  port        = 443
  protocol    = "HTTPS"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher            = "200-399"  # Broader range of acceptable status codes
    path               = "/healthcheckz"  # Common health check path
    port               = "traffic-port"
    timeout            = 5
    unhealthy_threshold = 2
    }
}

resource "aws_lb_target_group_attachment" "application_load_balancer_https_target_group_attachment" {
  depends_on = [
    aws_lb_listener.application_load_balancer_https_listener
  ]
  target_group_arn = aws_lb_target_group.application_load_balancer_https_target_group.arn
  target_id        = aws_lb.application_load_balancer.arn
  port             = 443
} 

resource "aws_lb_target_group" "application_load_balancer_http_target_group" {
  name        = "alb-http-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_lb_target_group_attachment" "application_load_balancer_http_target_group_attachment" {
  depends_on = [
    aws_lb_listener.application_load_balancer_http_listener
  ]
  target_group_arn = aws_lb_target_group.application_load_balancer_http_target_group.arn
  target_id        = aws_lb.application_load_balancer.arn
  port             = 80
} 