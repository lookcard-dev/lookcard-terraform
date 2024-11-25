resource "aws_security_group" "crypto-api-sg" {
  depends_on  = [var.network]
  name        = "crypto-api-service-security-group"
  description = "Security group for Crypto API services"
  vpc_id      = var.network.vpc

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    # cidr_blocks = ["0.0.0.0/0"]
    security_groups = [var.sg_alb_id, var.account_api_sg_id, var.lambda_cryptocurrency_sweeper.lambda_aggregator_tron_sg.id, var.lambda_cryptocurrency_withdrawal.crypto_fund_withdrawal_sg.id, var.transaction_listener_sg_id, var.reseller_api_sg, var.bastion_sg]

  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    # cidr_blocks = ["0.0.0.0/0"]
    security_groups = [var.sg_alb_id, var.account_api_sg_id, var.lambda_cryptocurrency_sweeper.lambda_aggregator_tron_sg.id, var.lambda_cryptocurrency_withdrawal.crypto_fund_withdrawal_sg.id, var.transaction_listener_sg_id, var.reseller_api_sg, var.bastion_sg]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "crypto-api-security-group"
  }
}