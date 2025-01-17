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
      security_groups = [var.referral_api_sg, var.verification_api_sg, var.lambda_firebase_authorizer_sg_id, var.reseller_api_sg, var.account_api_sg, var.bastion_sg, var.crypto_api_sg_id, var.user_api_sg] #var._auth_api_sg
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

resource "aws_security_group" "profile_api_ecs_svc_sg" {
  depends_on  = [var.network]
  name        = "${local.application.name}-ecs-svc-sg"
  description = "Use for ECS service - ${local.application.name}"
  vpc_id      = var.network.vpc

  dynamic "ingress" {
    for_each = [8080]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      security_groups = local.inbound_allow_sg_list[*]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.application.name}-ecs-svc-sg"
  }
}