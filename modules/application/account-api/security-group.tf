resource "aws_security_group" "account_api_sg" {
  depends_on  = [var.vpc_id]
  name        = "Account-API-Service-Security-Group"
  description = "Security group for Account API services"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    # cidr_blocks = ["0.0.0.0/0"]
    security_groups = [var.sg_alb_id, var.lambda_cryptocurrency_sweeper.lambda_aggregator_tron_sg.id, var.lambda_cryptocurrency_withdrawal.crypto_fund_withdrawal_sg.id, var.reseller_api_sg, var.bastion_sg]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # cidr_blocks = ["0.0.0.0/0"]
    security_groups = [var.sg_alb_id, var.lambda_cryptocurrency_sweeper.lambda_aggregator_tron_sg.id, var.lambda_cryptocurrency_withdrawal.crypto_fund_withdrawal_sg.id, var.reseller_api_sg, var.bastion_sg] #var.reseller_api_sg
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
