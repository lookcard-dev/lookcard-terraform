resource "aws_security_group" "eliptic_sg" {
  name        = "eliptic-sg"
  description = "Security group for eliptic lambda"
  vpc_id      = var.network.vpc


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eliptic-sg"
  }
}
