resource "aws_security_group" "application_load_balancer_security_group" {
  name   = "alb-sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "Application Load Balancer Security Group"
  }
}

resource "aws_vpc_security_group_egress_rule" "application_load_balancer_egress_rule" {
  security_group_id = aws_security_group.application_load_balancer_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "application_load_balancer_ingress_rule" {
  security_group_id            = aws_security_group.application_load_balancer_security_group.id
  referenced_security_group_id = aws_security_group.network_load_balancer_security_group.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
  lifecycle {
    ignore_changes = [
      referenced_security_group_id
    ]
  }
}

resource "aws_security_group" "network_load_balancer_security_group" {
  name   = "nlb-sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "Network Load Balancer Security Group"
  }
}

resource "aws_vpc_security_group_egress_rule" "network_load_balancer_egress_rule" {
  security_group_id = aws_security_group.network_load_balancer_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


resource "aws_vpc_security_group_ingress_rule" "bastion_host_ingress_rule" {
  security_group_id            = aws_security_group.application_load_balancer_security_group.id
  referenced_security_group_id = var.bastion_host_security_group_id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
}
