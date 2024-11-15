resource "aws_security_group" "reap_webhook_sg" {
  depends_on  = [var.network]
  name        = "reap-webhook-service-security-group"
  description = "Security group for reap-webhook services"
  vpc_id      = var.network.vpc

#   dynamic "ingress" {
#     for_each = [8080, 80]
#     content {
#       from_port = ingress.value
#       to_port   = ingress.value
#       protocol  = "tcp"
#       # cidr_blocks = ["0.0.0.0/0"]
#       # security_groups = [ ]
#     }
#   }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "reap-webhook-security-group"
  }
}