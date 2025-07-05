# resource "cloudflare_zero_trust_tunnel_cloudflared" "tunnel" {
#   account_id = var.cloudflare_provider.account_id

#   name          = "FusionAuth - ${upper(var.runtime_environment)}"
#   tunnel_secret = random_password.tunnel_secret.result
# }

# resource "random_password" "tunnel_secret" {
#   length  = 32
#   special = false
# }

# resource "cloudflare_zero_trust_access_application" "application" {
#   account_id = var.cloudflare_provider.account_id

#   name   = "FusionAuth - ${upper(var.runtime_environment)}"
#   domain = "fusionauth.${var.domain.admin.name}"

#   type                 = "self_hosted"
#   session_duration     = "24h"
#   app_launcher_visible = true
# }
