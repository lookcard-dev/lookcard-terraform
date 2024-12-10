data "aws_route53_zone" "hosted_zone_id" {
  name = var.domain
}

resource "aws_route53_record" "webhook" {
  zone_id = data.aws_route53_zone.hosted_zone_id.zone_id
  name    = var.dns_config.webhook_hostname
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.webhook.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.webhook.cloudfront_zone_id
    evaluate_target_health = true
  }
}

