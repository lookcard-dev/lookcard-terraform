resource "aws_security_group" "lambda_cryptocurrency_fund_withdrawal_sg" {
  name        = "Lambda-Cryptocurrency-Fund-Withdrawal-Security-Group"
  description = "Security group for Lambda Cryptocurrency Fund Withdrawal"
  vpc_id      = var.network.vpc

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lambda_cryptocurrency_fund_withdrawal_sg"
  }
}
