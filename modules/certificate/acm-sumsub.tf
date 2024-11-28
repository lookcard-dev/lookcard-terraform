

# admin.test.lookcard.io
resource "aws_acm_certificate" "sumsub_webhook" {
  domain_name       = var.sumsub_webhook_hostname
  validation_method = "DNS"
  provider          = aws.east
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "sumsub_webhook_cert" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.sumsub_webhook.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.sumsub_webhook.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.sumsub_webhook.domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.hosted_zone_id.zone_id
  ttl             = 60
}

resource "aws_acm_certificate_validation" "sumsub_webhook_validation" {
  provider                = aws.east
  certificate_arn         = aws_acm_certificate.sumsub_webhook.arn
  validation_record_fqdns = [aws_route53_record.sumsub_webhook_cert.fqdn]
}


