resource "aws_security_group" "referral_api_security_group" {
  depends_on  = [var.vpc_id]
  name        = "referral-api-security-group"
  description = "Security group for ECS referral-api"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = [8080, 80]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      # cidr_blocks = ["0.0.0.0/0"]
      security_groups = [var._auth_api_sg]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "referral-api-sg"
  }
}
