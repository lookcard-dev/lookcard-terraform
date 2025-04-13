resource "aws_security_group" "security_group" {
  depends_on = [var.network]
  name       = "${var.name}-ecs-svc-sg"
  vpc_id     = var.network.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rule" {
  security_group_id            = aws_security_group.security_group.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port                    = 2337
  to_port                      = 2337
  ip_protocol                  = "udp"
  lifecycle {
    ignore_changes = [
      referenced_security_group_id
    ]
  }
}