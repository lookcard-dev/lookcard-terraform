data "aws_security_group" "bastion_host" {
  name = "bastion-host-sg"
}

resource "aws_security_group" "cluster_security_group" {
  name        = "datacache-sg"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Datacache Security Group"
    Environment = var.runtime_environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_security_group_rule" "cluster_ingress_rules" {
  count = length(concat(var.allow_from_security_group_ids, [data.aws_security_group.bastion_host.id]))

  type                     = "ingress"
  from_port               = 6379
  to_port                 = 6379
  protocol                = "tcp"
  source_security_group_id = element(concat(var.allow_from_security_group_ids, [data.aws_security_group.bastion_host.id]), count.index)
  security_group_id       = aws_security_group.cluster_security_group.id
}