resource "aws_security_group" "cluster_security_group" {
  name   = "datastore-sg"
  vpc_id = var.vpc_id

  tags = {
    Name        = "Datastore Security Group"
    Environment = var.runtime_environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_vpc_security_group_egress_rule" "cluster_egress_rule" {
  security_group_id = aws_security_group.cluster_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "bastion_host_ingress_rule" {
  count                        = var.runtime_environment != "production" ? 1 : 0
  security_group_id            = aws_security_group.cluster_security_group.id
  referenced_security_group_id = var.external_security_group_ids.bastion_host
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  lifecycle {
    ignore_changes = [
      referenced_security_group_id
    ]
  }
}

resource "aws_security_group" "proxy_security_group" {
  name   = "datastore-proxy-sg"
  vpc_id = var.vpc_id

  tags = {
    Name        = "Datastore Proxy Security Group"
    Environment = var.runtime_environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_vpc_security_group_egress_rule" "proxy_egress_rule" {
  security_group_id = aws_security_group.proxy_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "proxy_bastion_host_ingress_rule" {
  count                        = var.runtime_environment == "production" ? 1 : 0
  security_group_id            = aws_security_group.proxy_security_group.id
  referenced_security_group_id = var.external_security_group_ids.bastion_host
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  lifecycle {
    ignore_changes = [
      referenced_security_group_id
    ]
  }
}
