resource "aws_security_group" "security_group" {
  depends_on = [var.network]
  name       = "${var.name}-ecs-svc-sg"
  vpc_id     = var.network.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_security_group_ingress_rule" "target_ingress_rules" {
  count = length(coalesce(var.allow_to_security_group_ids, []))

  security_group_id            = var.allow_to_security_group_ids[count.index]
  referenced_security_group_id = aws_security_group.security_group.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
}

data "aws_security_group" "bastion_host_security_group" {
  name = "bastion-host-sg"
}

resource "aws_vpc_security_group_ingress_rule" "bastion_host_ingress_rule" {
  security_group_id            = aws_security_group.security_group.id
  referenced_security_group_id = data.aws_security_group.bastion_host_security_group.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
}

data "aws_security_group" "application_load_balancer_security_group" {
  name = "alb-sg"
}

resource "aws_vpc_security_group_ingress_rule" "application_load_balancer_ingress_rule" {
  security_group_id            = aws_security_group.security_group.id
  referenced_security_group_id = data.aws_security_group.application_load_balancer_security_group.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
}
