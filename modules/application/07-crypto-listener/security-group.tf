data "aws_security_group" "crypto_api" {
  name = "crypto-api-ecs-svc-sg"
}

data "aws_security_group" "listener_cluster" {
  name = "ecs-ec2-cluster-sg"
}

resource "aws_vpc_security_group_ingress_rule" "crypto_api_ingress_rule" {
  security_group_id            = data.aws_security_group.crypto_api.id
  referenced_security_group_id = data.aws_security_group.listener_cluster.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
}

data "aws_security_group" "xray_daemon_security_group" {
  name = "xray-daemon-ecs-svc-sg"
}

resource "aws_vpc_security_group_ingress_rule" "xray_daemon_ingress_rule" {
  security_group_id            = data.aws_security_group.xray_daemon_security_group.id
  referenced_security_group_id = data.aws_security_group.listener_cluster.id
  from_port                    = 2337
  to_port                      = 2337
  ip_protocol                  = "udp"
}