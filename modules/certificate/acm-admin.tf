

# admin.test.lookcard.io
resource "aws_acm_certificate" "admin" {
  domain_name       = var.admin_hostname
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


