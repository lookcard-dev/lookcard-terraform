resource "aws_security_group" "jumpserver_security_group" {
  name   = "jumpserver-sg"
  vpc_id = var.vpc_id
  tags = {
    Name        = "Jumpserver Security Group"
    Environment = var.runtime_environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rule_80" {
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.jumpserver_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rule_443" {
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.jumpserver_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rule_22" {
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
  security_group_id            = aws_security_group.jumpserver_security_group.id
  referenced_security_group_id = var.security_group_ids.bastion_host
}

resource "aws_vpc_security_group_egress_rule" "egress_rule" {
  ip_protocol       = "-1"
  security_group_id = aws_security_group.jumpserver_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
}