resource "aws_security_group" "cluster_security_group" {
  name        = "datacache-sg"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.allow_from_security_group_ids
    content {
      from_port       = 6379
      to_port         = 6379
      protocol        = "tcp"
      security_groups = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Datacache Security Group"
  }
}