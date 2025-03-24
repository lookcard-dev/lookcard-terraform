data "aws_security_group" "datacache" {
  name = "datacache-sg"
}

data "aws_security_group" "datastore" {
  name = "datastore-sg"
}

data "aws_security_group" "datastore_proxy" {
  name = "datastore-proxy-sg"
}

data "aws_security_group" "bastion_host" {
  name = "bastion-host-sg"
}

resource "aws_security_group_rule" "datastore_ingress_rules" {
  count = var.runtime_environment == "production" ? 1 : length(concat(local.allow_to_datastore_security_group_ids, [data.aws_security_group.bastion_host.id]))

  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = var.runtime_environment == "production" ? data.aws_security_group.datastore_proxy.id : element(concat(local.allow_to_datastore_security_group_ids, [data.aws_security_group.bastion_host.id]), count.index)
  security_group_id        = data.aws_security_group.datastore.id
}

resource "aws_security_group_rule" "datastore_proxy_ingress_rules" {
  count = length(concat(local.allow_to_datastore_security_group_ids, [data.aws_security_group.bastion_host.id]))

  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = element(concat(local.allow_to_datastore_security_group_ids, [data.aws_security_group.bastion_host.id]), count.index)
  security_group_id        = data.aws_security_group.datastore_proxy.id
}

resource "aws_security_group_rule" "datacache_ingress_rules" {
  count = var.runtime_environment == "production" ? 1 : length(concat(local.allow_to_datacache_security_group_ids, [data.aws_security_group.bastion_host.id]))

  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = element(concat(local.allow_to_datacache_security_group_ids, [data.aws_security_group.bastion_host.id]), count.index)
  security_group_id        = data.aws_security_group.datacache.id
}
