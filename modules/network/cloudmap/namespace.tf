resource "aws_service_discovery_private_dns_namespace" "local" {
  name = "lookcard.local"
  vpc  = var.vpc_id
}