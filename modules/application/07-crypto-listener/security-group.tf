data "aws_security_group" "listener_cluster" {
  name = "ecs-ec2-cluster-sg"
}

resource "aws_vpc_security_group_ingress_rule" "target_ingress_rules" {
  count = length(coalesce(var.allow_to_security_group_ids, []))

  security_group_id            = var.allow_to_security_group_ids[count.index]
  referenced_security_group_id = data.aws_security_group.listener_cluster.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
}