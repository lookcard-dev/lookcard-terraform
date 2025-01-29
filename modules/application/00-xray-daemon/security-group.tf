resource "aws_security_group" "security_group" {
  depends_on  = [var.network]
  name        = "${var.name}-ecs-svc-sg"
  vpc_id      = var.network.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}