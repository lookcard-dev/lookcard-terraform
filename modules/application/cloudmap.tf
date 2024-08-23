resource "aws_service_discovery_private_dns_namespace" "lookcardlocal_namespace" {
  name = "lookcard.local"
  vpc  = var.network.vpc
}

# resource "aws_service_discovery_private_dns_namespace" "api_lookcardlocal_namespace" {
#   name = "api.lookcard.local"
#   vpc  = var.network.vpc
# }

# resource "aws_service_discovery_service" "xray_daemon_service" {
#   name = "xray.daemon"
#   dns_config {
#     namespace_id = aws_service_discovery_private_dns_namespace.lookcardlocal_namespace.id
#     dns_records {
#       ttl  = 10
#       type = "A"
#     }
#   }
#   health_check_custom_config {
#     failure_threshold = 1
#   }
# }
