resource "aws_cloudfront_origin_access_control" "reseller_portal_oac" {
  name                              = var.reseller_portal_bucket.bucket_domain_name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "reseller_portal" {
  origin {
    domain_name              = var.reseller_portal_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.reseller_portal_oac.id
    origin_id                = var.reseller_portal_bucket.bucket_regional_domain_name
  }
  enabled = true
  viewer_certificate {
    acm_certificate_arn      = var.ssl_cert.reseller_portal.cert_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
  default_root_object = "index.html"
  aliases             = [var.alternate_reseller_domain_name]

  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 403
    response_page_path    = "/index.html"
    response_code         = 200
  }
  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 405
    response_page_path    = "/index.html"
    response_code         = 200
  }


  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.reseller_portal_bucket.bucket_regional_domain_name
    compress               = true
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    viewer_protocol_policy = "redirect-to-https"
  }
  logging_config {
    bucket          = var.cdn_logging_s3_bucket.bucket_domain_name
    include_cookies = true
    prefix          = "CDN-logs"

  }

  web_acl_id = aws_wafv2_web_acl.portal.arn
}

resource "aws_route53_record" "reseller_portal_record" {
  zone_id = data.aws_route53_zone.hosted_zone_id.zone_id
  name    = "console.reseller"
  type    = "CNAME"
  ttl     = 300
  records = [aws_cloudfront_distribution.reseller_portal.domain_name]
}
