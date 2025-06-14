resource "aws_acm_certificate" "certificate" {
  domain_name       = "webhook.${var.domain.general.name}"
  validation_method = "DNS"
  provider          = aws.us_east_1
}

resource "cloudflare_certificate_pack" "certificate_pack" {
  zone_id               = var.domain.general.zone_id
  certificate_authority = "google"
  hosts                 = ["webhook.${var.domain.general.name}"]
  type                  = "advanced"
  validation_method     = "txt"
  validity_days         = 90
  cloudflare_branding   = false
}