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

