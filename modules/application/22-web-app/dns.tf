resource "cloudflare_dns_record" "target" {
  depends_on = [aws_cloudfront_distribution.web_app]

  zone_id = var.domain.general.zone_id
  name    = "app.${var.domain.general.name}"
  content = aws_cloudfront_distribution.web_app.domain_name
  type    = "CNAME"
  ttl     = 1 # 1 second TTL for faster DNS propagation
  proxied = true # Proxy through Cloudflare since we're using CloudFront
  comment = "Web App - CloudFront Distribution"
}

# DNS validation records for ACM certificate
resource "cloudflare_dns_record" "certificate_validation" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = var.domain.general.zone_id
  name    = each.value.name
  content = each.value.record
  type    = each.value.type
  ttl     = 3600
  proxied = false
  comment = "Web App Certificate Validation - ACM"
}

# ACM certificate validation
resource "aws_acm_certificate_validation" "certificate_validation" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in cloudflare_dns_record.certificate_validation : record.name]
  provider                = aws.us_east_1
}

