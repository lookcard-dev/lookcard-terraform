resource "aws_acm_certificate" "reseller_api" {
  domain_name       = var.apigw_reseller_hostname
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "reseller_api_certs" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.reseller_api.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.reseller_api.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.reseller_api.domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.hosted_zone_id.zone_id
  ttl             = 60
}

resource "aws_acm_certificate_validation" "reseller_api_validation" {
  certificate_arn         = aws_acm_certificate.reseller_api.arn
  validation_record_fqdns = [aws_route53_record.reseller_api_certs.fqdn]
}
