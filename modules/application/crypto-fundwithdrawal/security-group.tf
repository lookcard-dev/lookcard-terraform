resource "aws_security_group" "crypto_fund_withdrawal_sg" {
  name        = "Lambda-Crypto-Fund-Withdrawal-Security-Group"
  description = "Security group for Lambda Crypto Fund Withdrawal"
  vpc_id      = var.network.vpc

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lambda_crypto_fund_withdrawal_sg"
  }
}
