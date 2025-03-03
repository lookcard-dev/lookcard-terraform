data "aws_route53_zone" "zone" {
  name     = var.general_domain
  provider = aws.dns
}

# Create Route53 record to point to API Gateway custom domain
resource "aws_route53_record" "webhook_api" {
  provider = aws.dns

  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "webhook.${var.general_domain}"
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.webhook_domain.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.webhook_domain.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "certificate_validation" {
  provider = aws.dns
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone.zone_id
}

# Wait for certificate validation to complete
resource "aws_acm_certificate_validation" "certificate_validation" {
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate_validation : record.fqdn]
}

