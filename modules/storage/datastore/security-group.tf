data "aws_security_group" "bastion_host" {
  name = "bastion-host-sg"
}

resource "aws_security_group" "cluster_security_group" {
  name        = "datastore-sg"
  vpc_id      = var.vpc_id

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

resource "aws_security_group_rule" "cluster_ingress_rules" {
  count = var.runtime_environment == "production" ? 1 : length(concat(var.allow_from_security_group_ids, [data.aws_security_group.bastion_host.id]))

  type                     = "ingress"
  from_port               = 5432
  to_port                 = 5432
  protocol                = "tcp"
  source_security_group_id = var.runtime_environment == "production" ? aws_security_group.proxy_security_group.id : element(concat(var.allow_from_security_group_ids, [data.aws_security_group.bastion_host.id]), count.index)
  security_group_id       = aws_security_group.cluster_security_group.id
}

resource "aws_security_group" "proxy_security_group" {
  name        = "datastore-proxy-sg"
  vpc_id      = var.vpc_id

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

resource "aws_security_group_rule" "proxy_ingress_rules" {
  count = length(concat(var.allow_from_security_group_ids, [data.aws_security_group.bastion_host.id]))

  type                     = "ingress"
  from_port               = 5432
  to_port                 = 5432
  protocol                = "tcp"
  source_security_group_id = element(concat(var.allow_from_security_group_ids, [data.aws_security_group.bastion_host.id]), count.index)
  security_group_id       = aws_security_group.proxy_security_group.id
}