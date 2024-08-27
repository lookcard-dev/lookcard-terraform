# Create Security Group for the Service
resource "aws_security_group" "Authentication" {
  depends_on  = [var.vpc_id]
  name        = "Authentication-Service-Security-Group"
  description = "Security group for ECS services"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 8000
    to_port   = 8000
    protocol  = "tcp"
    security_groups = [var.sg_alb_id]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Authentication-Security-Group"
  }
}
