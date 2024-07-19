resource "aws_security_group" "xray_daemon_sg" {
  depends_on  = [var.network]
  name        = "XRayDaemon-Service-Security-Group"
  description = "Security group for ECS services"
  vpc_id      = var.network.vpc

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "XRayDaemon-Security-Group"
  }
}
