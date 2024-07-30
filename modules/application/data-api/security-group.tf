resource "aws_security_group" "data-api-sg" {
  depends_on  = [var.network]
  name        = "data-api-service-security-group"
  description = "Security group for Data API services"
  vpc_id      = var.network.vpc

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
    Name = "data-api-security-group"
  }
}
