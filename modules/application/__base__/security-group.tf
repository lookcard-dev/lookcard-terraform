resource "aws_security_group" "security_group" {
  depends_on = [var.network]
  name       = "${var.name}-ecs-svc-sg"
  vpc_id     = var.network.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "base_egress_rule" {
  security_group_id = aws_security_group.security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "target_ingress_rules" {
  count = length(coalesce(var.allow_to_security_group_ids, []))

  security_group_id            = var.allow_to_security_group_ids[count.index]
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

resource "aws_vpc_security_group_ingress_rule" "bastion_host_ingress_rule" {
  security_group_id            = aws_security_group.security_group.id
  referenced_security_group_id = var.external_security_group_ids.bastion_host
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
  lifecycle {
    ignore_changes = [
      referenced_security_group_id
    ]
  }
}


