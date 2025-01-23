resource "aws_security_group" "lambda_firebase_authorizer_sg" {
  name        = "lambda-firebase-authorizer-sg"
  description = "Security group for Lambda Firebase_Authorizer"
  vpc_id      = var.network.vpc

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lambda-firebase-authorizer-sg"
  }
}

resource "aws_security_group" "firebase_authorizer_lambda_func_sg" {
  depends_on  = [var.network]
  name        = "firebase-authorizer-lambda-func-sg"
  description = "Use for Lambda function - firebase-authorizer"
  vpc_id      = var.network.vpc

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "firebase-authorizer-lambda-func-sg"
  }
}