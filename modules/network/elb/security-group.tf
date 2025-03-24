resource "aws_security_group" "composite_application_load_balancer_security_group" {
  name   = "composite-alb-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.composite_network_load_balancer_security_group.id]
    description     = "Allow inbound traffic from the composite network load balancer"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound traffic to all destinations"
  }

  tags = {
    Name = "Composite Application Load Balancer Security Group"
  }
}

resource "aws_security_group" "core_application_load_balancer_security_group" {
  name   = "core-alb-sg"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound traffic to all destinations"
  }

  tags = {
    Name = "Core Application Load Balancer Security Group"
  }
}

resource "aws_security_group" "composite_network_load_balancer_security_group" {
  name   = "composite-nlb-sg"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound traffic to all destinations"
  }

  tags = {
    Name = "Composite Network Load Balancer Security Group"
  }
}