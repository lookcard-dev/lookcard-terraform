resource "aws_security_group" "user_api" {
  depends_on  = [var.network]
  name        = "Users-Service-Security-Group"
  description = "Security group for ECS services"
  vpc_id      = var.network.vpc

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    # cidr_blocks = ["0.0.0.0/0"]
    security_groups = [var.sg_alb_id, var.lambda.lambda_aggregator_tron_sg_id, var.lambda.crypto_fund_withdrawal_sg_id]
}


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # cidr_blocks = ["0.0.0.0/0"]
    security_groups = [var.sg_alb_id, var.lambda.lambda_aggregator_tron_sg_id, var.lambda.crypto_fund_withdrawal_sg_id]
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Users-Security-Group"
  }
}
