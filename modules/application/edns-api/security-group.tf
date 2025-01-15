resource "aws_security_group" "edns_api_sg" {
  depends_on  = [var.vpc_id]
  name        = "Edns-API-Service-Security-Group"
  description = "Security group for Edns API services"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080  
    protocol    = "tcp"
    security_groups = [var.sg_alb_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Edns-API-Security-Group"
  }
}

resource "aws_security_group" "edns_api_ecs_svc_sg" {
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