resource "aws_security_group" "reap_proxy_sg" {
  depends_on  = [var.vpc_id]
  name        = "reap-proxy-security-group"
  description = "Security group for ECS reap-proxy"
  vpc_id      = var.vpc_id

#   dynamic "ingress" {
#     for_each = [8080, 80]
#     content {
#       from_port   = ingress.value
#       to_port     = ingress.value
#       protocol    = "tcp"
#       # cidr_blocks = ["0.0.0.0/0"]
#       security_groups = [var.sg_alb_id]
#     }
#   }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "reap-proxy-sg"
  }
}
