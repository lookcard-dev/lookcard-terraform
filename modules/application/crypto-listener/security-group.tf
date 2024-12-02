
resource "aws_security_group" "transaction_listener_sg" {
  depends_on  = [var.vpc_id]
  name        = "Transaction-Listener-Service-Security-Group"
  description = "Security group for Transaction Listener services"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Transaction-Listener-Security-Group"
  }
}

resource "aws_security_group" "tron_listener_ecs_svc_sg" {
  depends_on  = [var.network]
  name        = "tron-listener-ecs-svc-sg"
  description = "Use for ECS service - crypto-listener"
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
    Name = "tron-listener-ecs-svc-sg"
  }
}