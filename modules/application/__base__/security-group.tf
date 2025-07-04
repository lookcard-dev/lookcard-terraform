# Data source to get ALB security groups
data "aws_lb" "application_load_balancer" {
  arn = var.elb.application_load_balancer_arn
}

resource "aws_security_group" "security_group" {
  depends_on = [var.network]
  name       = "${var.name}-ecs-svc-sg"
  vpc_id     = var.network.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "base_egress_rule" {
  security_group_id = aws_security_group.security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Allow traffic from ALB security groups
resource "aws_vpc_security_group_ingress_rule" "alb_ingress_rule" {
  count = length(data.aws_lb.application_load_balancer.security_groups)

  security_group_id            = aws_security_group.security_group.id
  referenced_security_group_id = data.aws_lb.application_load_balancer.security_groups[count.index]
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"

  lifecycle {
    ignore_changes = [
      referenced_security_group_id
    ]
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_ingress_rule" {
  count = length(data.aws_lb.application_load_balancer.security_groups)

  security_group_id            = data.aws_lb.application_load_balancer.security_groups[count.index]
  referenced_security_group_id = aws_security_group.security_group.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"

  lifecycle {
    ignore_changes = [
      referenced_security_group_id
    ]
  }
}
