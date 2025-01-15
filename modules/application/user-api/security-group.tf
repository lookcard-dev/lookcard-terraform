resource "aws_security_group" "user_api_security_grp" {
  depends_on  = [var.vpc_id]
  name        = "User-API-Service-Security-Group"
  description = "Security group for User API services"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = [8080, 80]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      # cidr_blocks = ["0.0.0.0/0"]
      security_groups = [var.sg_alb_id, var.lambda_firebase_authorizer_sg_id, var.bastion_sg, var.reseller_api_sg]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "user-api-sg"
  }
}

resource "aws_security_group" "user_api_ecs_svc_sg" {
  depends_on  = [var.network]
  name        = "${local.application.name}-ecs-svc-sg"
  description = "Use for ECS service - ${local.application.name}"
  vpc_id      = var.network.vpc

  dynamic "ingress" {
    for_each = [8080, 80]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
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