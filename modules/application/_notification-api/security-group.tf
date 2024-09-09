resource "aws_security_group" "notification" {
  depends_on  = [var.network]
  name        = "Notification-Service-Security-Group"
  description = "Security group for ECS services"
  vpc_id      = var.network.vpc

  ingress {
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    # cidr_blocks = ["0.0.0.0/0"]
    security_groups = [var.sg_alb_id]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # cidr_blocks = ["0.0.0.0/0"]
    security_groups = [var.sg_alb_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Notification-Serurity-Group"
  }
}
