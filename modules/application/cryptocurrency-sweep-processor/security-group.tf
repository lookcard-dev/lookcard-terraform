resource "aws_security_group" "lambda_cryptocurrency_sweep_processor_sg" {
  name        = "Lambda_Cryptocurrency_Sweep_Processor-Security-Groups"
  description = "Security group for Lambda Cryptocurrency Sweep Processor"
  vpc_id      = var.network.vpc

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lambda_aggregator-tron-sg"
  }
}

