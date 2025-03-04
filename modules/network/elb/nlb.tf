resource "aws_lb" "network_load_balancer" {
  name                                                         = "nlb"
  internal                                                     = true
  load_balancer_type                                           = "network"
  subnets                                                      = var.subnet_ids
  security_groups                                              = [aws_security_group.network_load_balancer_security_group.id]
  enforce_security_group_inbound_rules_on_private_link_traffic = "off"
  
  access_logs {
    enabled = can(data.aws_s3_bucket.logs_bucket[0]) ? true : false
    bucket  = "${var.aws_provider.account_id}-log"
    prefix  = "ELB/network/access_logs"
  }
}

resource "aws_lb_target_group" "network_load_balancer_http_target_group" {
  name        = "nlb-http-target"
  port        = 80
  target_type = "alb"
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  health_check {
    enabled           = true
    healthy_threshold = 2
    interval          = 30
    matcher           = "200-399"
    path              = "/healthcheckz"
  }
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
