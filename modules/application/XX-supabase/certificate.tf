resource "aws_acm_certificate" "api_certificate" {
  domain_name       = "supabase.${var.domain.general.name}"
  validation_method = "DNS"
  provider          = aws.us_east_1

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "supabase-api-acm-certificate"
    Environment = var.runtime_environment
    Service     = "supabase"
  }
}

resource "aws_acm_certificate" "studio_certificate" {
  domain_name       = "studio.supabase.${var.domain.admin.name}"
  validation_method = "DNS"
  provider          = aws.us_east_1

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "supabase-studio-acm-certificate"
    Environment = var.runtime_environment
    Service     = "supabase"
  }
}

resource "cloudflare_certificate_pack" "api_certificate_pack" {
  zone_id               = var.domain.general.zone_id
  certificate_authority = "google"
  hosts                 = ["supabase.${var.domain.general.name}"]
  type                  = "advanced"
  validation_method     = "txt"
  validity_days         = 90
  cloudflare_branding   = false
}

resource "cloudflare_certificate_pack" "studio_certificate_pack" {
  zone_id               = var.domain.admin.zone_id
  certificate_authority = "google"
  hosts                 = ["studio.supabase.${var.domain.admin.name}"]
  type                  = "advanced"
  validation_method     = "txt"
  validity_days         = 90
  cloudflare_branding   = false
}