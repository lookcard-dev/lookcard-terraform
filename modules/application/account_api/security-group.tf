resource "aws_security_group" "Account-API-SG" {
  depends_on  = [var.vpc_id]
  name        = "Account-API-Service-Security-Group"
  description = "Security group for Account API services"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [var.lambda.lambda_aggregator_tron_sg_id, var.api_alb_sg_id, var.lambda.crypto_fund_withdrawal_sg_id]
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
    Name = "Account-API-Security-Group"
  }
}
