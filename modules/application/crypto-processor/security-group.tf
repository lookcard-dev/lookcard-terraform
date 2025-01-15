resource "aws_security_group" "sweep_processor_security_group" {
  name   = "crypto-processor-sweep-processor-lambda-func-sg"
  vpc_id = var.network.vpc

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_security_group_ingress_rule" "sweep-processor-target-ingress-rules" {
  for_each = toset(var.allow_to_security_group_ids.sweep != null ? var.allow_to_security_group_ids.sweep : [])

  security_group_id            = each.value
  referenced_security_group_id = aws_security_group.sweep_processor_security_group.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
}
