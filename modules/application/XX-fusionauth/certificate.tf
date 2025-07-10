resource "aws_acm_certificate" "certificate" {
  domain_name       = "auth.${var.domain.general.name}"
  validation_method = "DNS"
  provider          = aws.us_east_1
}

resource "cloudflare_certificate_pack" "certificate_pack" {
  zone_id               = var.domain.general.zone_id
  certificate_authority = "google"
  hosts                 = ["auth.${var.domain.general.name}"]
  type                  = "advanced"
  validation_method     = "txt"
  validity_days         = 90
  cloudflare_branding   = false
}

resource "cloudflare_certificate_pack" "admin_certificate_pack" {
  zone_id               = var.domain.admin.zone_id
  certificate_authority = "google"
  hosts                 = ["fusionauth.${var.domain.admin.name}"]
  type                  = "advanced"
  validation_method     = "txt"
  validity_days         = 90
  cloudflare_branding   = false
}
