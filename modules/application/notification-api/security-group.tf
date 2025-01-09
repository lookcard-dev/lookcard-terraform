
resource "aws_security_group" "notification_api" {
  depends_on  = [var.network]
  name        = "Notification-api-Service-Security-Group"
  description = "Security group for ECS services"
  vpc_id      = var.network.vpc

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [var.sg_alb_id, var.bastion_sg]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [var.sg_alb_id, var.bastion_sg]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Notification-api-Serurity-Group"
  }
}

resource "aws_security_group" "data_api_ecs_svc_sg" {
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