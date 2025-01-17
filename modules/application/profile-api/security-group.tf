resource "aws_security_group" "security_group" {
  depends_on  = [var.network]
  name        = "${var.name}-ecs-svc-sg"
  vpc_id      = var.network.vpc

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_security_group_ingress_rule" "target_ingress_rules" {
  for_each = toset(var.allow_to_security_group_ids != null ? var.allow_to_security_group_ids : [])

  security_group_id            = each.value
  referenced_security_group_id = aws_security_group.security_group.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
}
