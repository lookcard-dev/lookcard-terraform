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


resource "aws_vpc_security_group_ingress_rule" "application_load_balancer_ingress_rule" {
  security_group_id            = aws_security_group.security_group.id
  referenced_security_group_id = var.external_security_group_ids.alb
  from_port                    = 9011
  to_port                      = 9011
  ip_protocol                  = "tcp"
  lifecycle {
    ignore_changes = [
      referenced_security_group_id
    ]
  }
}
