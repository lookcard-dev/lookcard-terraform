resource "aws_security_group" "lambda_aggregator_tron_sg" {
  name        = "Lambda_Aggregator-Tron-Security-Groups"
  description = "Security group for Lambda Aggregator Tron"
  vpc_id      = var.network.vpc
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Lambda_Aggregator-Tron-Security-Groups"
  }
}