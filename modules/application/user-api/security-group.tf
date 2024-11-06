resource "aws_security_group" "user_api_security_grp" {
  depends_on  = [var.vpc_id]
  name        = "User-API-Service-Security-Group"
  description = "Security group for User API services"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = [8080, 80]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      # cidr_blocks = ["0.0.0.0/0"]
      security_groups = [var.sg_alb_id, var.lambda_aggregator_tron_sg_id]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "user-api-sg"
  }
}
