resource "aws_security_group" "lambda_cryptocurrency_sweep_processor_sg" {
  name        = "${local.lambda_function.name}-sg"
  description = ""
  vpc_id      = var.network.vpc

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.lambda_function.name}-sg"
  }
}

