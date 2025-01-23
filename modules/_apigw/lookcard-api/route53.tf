data "aws_route53_zone" "hosted_zone_id" {
  name = var.domain
}

resource "aws_route53_record" "lookcard_api_record" {
  zone_id = data.aws_route53_zone.hosted_zone_id.zone_id
  name    = var.dns_config.api_hostname
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.lookcard_api.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.lookcard_api.cloudfront_zone_id
    evaluate_target_health = false
  }
}