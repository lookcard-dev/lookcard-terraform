resource "aws_vpc_security_group_ingress_rule" "target_ingress_rules" {
  count = length(coalesce(var.allow_to_security_group_ids, []))

  security_group_id            = var.allow_to_security_group_ids[count.index]
  referenced_security_group_id = var.external_security_group_ids.ecs_cluster
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
  lifecycle {
    ignore_changes = [
      referenced_security_group_id
    ]
  }
}