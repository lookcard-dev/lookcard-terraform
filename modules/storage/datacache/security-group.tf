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