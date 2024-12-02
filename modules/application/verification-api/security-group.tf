resource "aws_security_group" "verification_api_security_grp" {
  depends_on  = [var.vpc_id]
  name        = "verification-api-sg"
  description = "Security group for verification-api"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = [8080, 80]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      # cidr_blocks = ["0.0.0.0/0"]
      security_groups = [var.sg_alb_id, var.bastion_sg]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "verification-api-sg"
  }
}

resource "aws_security_group" "verification_api_ecs_svc_sg" {
  depends_on  = [var.network]
  name        = "verification-api-ecs-svc-sg"
  description = "Use for ECS service - verification-api"
  vpc_id      = var.network.vpc

  dynamic "ingress" {
    for_each = [8080, 80]
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
    Name = "verification-api-ecs-svc-sg"
  }
}