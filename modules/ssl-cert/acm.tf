data "aws_route53_zone" "hosted_zone_id" {
  name = var.domain
}

# app.test.lookcard.io
resource "aws_acm_certificate" "app" {
  domain_name       = var.frontend_hostname
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_route53_record" "lookcard_certs" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.app.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.app.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.app.domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.hosted_zone_id.zone_id
  ttl             = 60
}

resource "aws_acm_certificate_validation" "lookcard_validation" {
  certificate_arn         = aws_acm_certificate.app.arn
  validation_record_fqdns = [aws_route53_record.lookcard_certs.fqdn]
}

# admin.test.lookcard.io
resource "aws_acm_certificate" "admin" {
  domain_name       = var.admin_panel_hostname
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "admin_panel_certs" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.admin.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.admin.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.admin.domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.hosted_zone_id.zone_id
  ttl             = 60
}

resource "aws_acm_certificate_validation" "admin_panel_validation" {
  certificate_arn         = aws_acm_certificate.admin.arn
  validation_record_fqdns = [aws_route53_record.admin_panel_certs.fqdn]
}

# api.test.lookcard.io
resource "aws_acm_certificate" "api" {
  domain_name       = var.api_hostname
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "api_certs" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.api.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.api.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.api.domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.hosted_zone_id.zone_id
  ttl             = 60
}

resource "aws_acm_certificate_validation" "api_validation" {
  certificate_arn         = aws_acm_certificate.api.arn
  validation_record_fqdns = [aws_route53_record.api_certs.fqdn]
}
