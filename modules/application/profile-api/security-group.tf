resource "aws_security_group" "profile-api-sg" {
  depends_on  = [var.network]
  name        = "profile-api-service-security-group"
  description = "Security group for Profile API services"
  vpc_id      = var.network.vpc

  dynamic "ingress" {
    for_each = [8080, 80]
    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "tcp"
      # cidr_blocks = ["0.0.0.0/0"]
      security_groups = [var.sg_alb_id, var.referral_api_sg, var.verification_api_sg, var.lambda_firebase_authorizer_sg_id] #var._auth_api_sg
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "profile-api-security-group"
  }
}