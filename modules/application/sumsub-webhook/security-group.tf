resource "aws_security_group" "lambda_sumsub_webhook_sg" {
  name        = "lambda-sumsub-webhook-sg"
  description = "Security group for Lambda sumsub-webhook"
  vpc_id      = var.network.vpc

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lambda-sumsub-webhook-sg"
  }
}

