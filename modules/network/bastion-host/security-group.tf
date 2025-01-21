resource "aws_security_group" "bastion_host_security_group" {
  name        = "bastion-host-sg"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "Bastion Host Security Group"
    Environment = var.runtime_environment
    ManagedBy   = "Terraform"
  }
}