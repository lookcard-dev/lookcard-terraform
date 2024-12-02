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

resource "aws_security_group" "sumsub_webhook_lambda_func_sg" {
  depends_on  = [var.network]
  name        = "sumsub-webhook-lambda-func-sg"
  description = "Use for Lambda function - sumsub-webhook"
  vpc_id      = var.network.vpc

  # dynamic "ingress" {
  #   for_each = [8080, 80]
  #   content {
  #     from_port   = ingress.value
  #     to_port     = ingress.value
  #     protocol    = "tcp"
  #     security_groups = local.inbound_allow_sg_list[*]
  #   }
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sumsub-webhook-lambda-func-sg"
  }
}
