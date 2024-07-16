resource "aws_service_discovery_private_dns_namespace" "lookcardlocal_namespace" {
  name = "lookcard.local"
  vpc  = var.network.vpc
}

resource "aws_service_discovery_private_dns_namespace" "api_lookcardlocal_namespace" {
  name = "api.lookcard.local"
  vpc  = var.network.vpc
}
