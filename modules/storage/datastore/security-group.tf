data "aws_security_group" "bastion_host" {
  name = "bastion-host-sg"
}

resource "aws_security_group" "cluster_security_group" {
  name   = "datastore-sg"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Datastore Security Group"
    Environment = var.runtime_environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "bastion_host_ingress_rule" {
  count                        = var.runtime_environment != "production" ? 1 : 0
  security_group_id            = aws_security_group.cluster_security_group.id
  referenced_security_group_id = data.aws_security_group.bastion_host.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
}

resource "aws_security_group" "proxy_security_group" {
  name   = "datastore-proxy-sg"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Datastore Proxy Security Group"
    Environment = var.runtime_environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "proxy_bastion_host_ingress_rule" {
  count                        = var.runtime_environment == "production" ? 1 : 0
  security_group_id            = aws_security_group.proxy_security_group.id
  referenced_security_group_id = data.aws_security_group.bastion_host.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
}
