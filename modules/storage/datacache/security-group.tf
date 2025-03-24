data "aws_security_group" "bastion_host" {
  name = "bastion-host-sg"
}

resource "aws_security_group" "cluster_security_group" {
  name   = "datacache-sg"
  vpc_id = var.vpc_id

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

resource "aws_vpc_security_group_ingress_rule" "bastion_host_ingress_rule" {
  security_group_id            = aws_security_group.cluster_security_group.id
  referenced_security_group_id = data.aws_security_group.bastion_host.id
  from_port                    = 6379
  to_port                      = 6379
  ip_protocol                  = "tcp"
}