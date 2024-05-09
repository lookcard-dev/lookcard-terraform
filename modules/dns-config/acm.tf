resource "aws_acm_certificate" "lookcard" {
  domain_name       = var.host_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "lookcard_certs" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.lookcard.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.lookcard.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.lookcard.domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.production_api.zone_id
  ttl             = 60
}

resource "aws_acm_certificate_validation" "lookcard_validation" {
  certificate_arn         = aws_acm_certificate.lookcard.arn
  validation_record_fqdns = [aws_route53_record.lookcard_certs.fqdn]
}


resource "aws_acm_certificate" "admin_panel" {
  domain_name       = var.admin_panel_host_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "admin_panel_certs" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.admin_panel.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.admin_panel.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.admin_panel.domain_validation_options)[0].resource_record_type
  zone_id         = aws_route53_zone.production_admin_panel.zone_id
  ttl             = 60
}

resource "aws_acm_certificate_validation" "admin_panel_validation" {
  certificate_arn         = aws_acm_certificate.admin_panel.arn
  validation_record_fqdns = [aws_route53_record.admin_panel_certs.fqdn]
}
