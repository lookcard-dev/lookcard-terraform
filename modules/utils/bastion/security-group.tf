resource "aws_security_group" "bastion_sg" {
  name        = "bastion-security-group"
  description = "Security group for bastion host"
  vpc_id      = var.network.vpc
  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-security-group"
  }
}

resource "aws_security_group" "bastion_host_sg" {
  depends_on  = [var.network]
  name        = "bastion-host-sg"
  description = "Use for Bastion Host"
  vpc_id      = var.network.vpc

  dynamic "ingress" {
    for_each = [0]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-host-sg"
  }
}