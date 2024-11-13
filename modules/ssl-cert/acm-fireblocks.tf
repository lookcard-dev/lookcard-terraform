resource "aws_acm_certificate" "fireblocks_webhook" {
  domain_name       = var.fireblocks_webhook_hostname
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "fireblocks_webhook_cert" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.fireblocks_webhook.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.fireblocks_webhook.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.fireblocks_webhook.domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.hosted_zone_id.zone_id
  ttl             = 60
}

resource "aws_acm_certificate_validation" "fireblocks_webhook_validation" {
  certificate_arn         = aws_acm_certificate.fireblocks_webhook.arn
  validation_record_fqdns = [aws_route53_record.fireblocks_webhook_cert.fqdn]
}