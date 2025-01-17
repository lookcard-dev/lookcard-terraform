resource "aws_lb" "network_load_balancer" {
  name               = "nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.network_load_balancer_security_group.id]
}

resource "aws_lb_target_group" "network_load_balancer_target_group" {
  name        = "nlb-target"
  port        = 80
  target_type = "alb"
  protocol    = "TCP"
  vpc_id      = var.vpc_id
}

resource "aws_lb_target_group_attachment" "network_load_balancer_target_group_attachment" {
  target_group_arn = aws_lb_target_group.network_load_balancer_target_group.arn
  target_id        = aws_lb.application_load_balancer.arn
  port             = 80
}

# Create NLB Listener
resource "aws_lb_listener" "network_load_balancer_listener" {
  load_balancer_arn = aws_lb.network_load_balancer.arn
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.network_load_balancer_target_group.arn
  }
}