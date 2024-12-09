resource "aws_route53_record" "sumsub_webhook" {
  zone_id = data.aws_route53_zone.hosted_zone_id.zone_id
  name    = var.dns_config.sumsub_webhook_hostname
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.sumsub_webhook.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.sumsub_webhook.cloudfront_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "reap_webhook" {
  zone_id = data.aws_route53_zone.hosted_zone_id.zone_id
  name    = var.dns_config.reap_webhook_hostname
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.reap_webhook.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.reap_webhook.cloudfront_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "firebase_webhook" {
  zone_id = data.aws_route53_zone.hosted_zone_id.zone_id
  name    = var.dns_config.firebase_webhook_hostname
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.firebase_webhook.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.firebase_webhook.cloudfront_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "fireblocks_webhook" {
  zone_id = data.aws_route53_zone.hosted_zone_id.zone_id
  name    = var.dns_config.fireblocks_webhook_hostname
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.fireblocks_webhook.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.fireblocks_webhook.cloudfront_zone_id
    evaluate_target_health = true
  }
}