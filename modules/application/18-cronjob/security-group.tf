data "aws_security_group" "account_api_security_group" {
  name = "account-api-ecs-svc-sg"
}

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

data "aws_security_group" "xray_daemon_security_group" {
  name = "xray-daemon-ecs-svc-sg"
}

resource "aws_vpc_security_group_ingress_rule" "xray_daemon_ingress_rule" {
  security_group_id            = data.aws_security_group.xray_daemon_security_group.id
  referenced_security_group_id = aws_security_group.security_group.id
  from_port                    = 2337
  to_port                      = 2337
  ip_protocol                  = "udp"
}