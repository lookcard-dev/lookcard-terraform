data "aws_security_group" "datastore_cluster_security_group" {
  name = "datastore-sg"
}

data "aws_security_group" "datastore_proxy_security_group" {
  name = "datastore-proxy-sg"
}

data "aws_security_group" "datacache_cluster_security_group" {
  name = "datacache-sg"
}

resource "aws_security_group_rule" "datastore_ingress_rules" {
  count = var.runtime_environment == "production" ? 0 : length(local.datastore_access_security_group_ids)

  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = element(local.datastore_access_security_group_ids, count.index)
  security_group_id        = data.aws_security_group.datastore_cluster_security_group.id
}

resource "aws_security_group_rule" "datastore_proxy_ingress_rules" {
  count = var.runtime_environment == "production" ? length(local.datastore_access_security_group_ids) : 0

  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = element(local.datastore_access_security_group_ids, count.index)
  security_group_id        = data.aws_security_group.datastore_proxy_security_group.id
}

resource "aws_security_group_rule" "datacache_ingress_rules" {
  count = length(local.datacache_access_security_group_ids)

  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = element(local.datacache_access_security_group_ids, count.index)
  security_group_id        = data.aws_security_group.datacache_cluster_security_group.id
}
