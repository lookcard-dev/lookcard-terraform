

# data "aws_route53_zone" "hosted_zone_id" {
#   name = var.environment.domain
# }

# resource "aws_cloudfront_origin_access_control" "lookcard_metadata_oac" {
#   name                              = aws_s3_bucket.lookcard_metadata.bucket_domain_name
#   origin_access_control_origin_type = "s3"
#   signing_behavior                  = "always"
#   signing_protocol                  = "sigv4"
# }


# resource "aws_acm_certificate" "cdn_cert" {
#   provider = aws.us-east-1
#   domain_name       = "download.${var.environment.domain}"
#   validation_method = "DNS"

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_acm_certificate_validation" "cdn_cert" {
#   provider = aws.us-east-1
#   certificate_arn         = aws_acm_certificate.cdn_cert.arn
#   validation_record_fqdns = [for record in aws_route53_record.cdn_cert_validation : record.fqdn]
# }


# resource "aws_cloudfront_distribution" "lookcard_metadata_cdn" {
#   origin {
#     domain_name              = aws_s3_bucket.lookcard_metadata.bucket_regional_domain_name
#     origin_access_control_id = aws_cloudfront_origin_access_control.lookcard_metadata_oac.id
#     origin_id                = aws_s3_bucket.lookcard_metadata.bucket_regional_domain_name
#   }

#   enabled = true
  
#   aliases = ["download.${var.environment.domain}"]

#   viewer_certificate {
#     acm_certificate_arn = aws_acm_certificate.cdn_cert.arn
#     ssl_support_method  = "sni-only"
#     minimum_protocol_version = "TLSv1.2_2021"
#   }

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#       locations        = []
#     }
#   }

#   default_cache_behavior {
#     allowed_methods        = ["GET", "HEAD"]
#     cached_methods         = ["GET", "HEAD"]
#     target_origin_id       = aws_s3_bucket.lookcard_metadata.bucket_regional_domain_name
#     compress               = true
#     cache_policy_id        = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" # CachingDisabled
#     viewer_protocol_policy = "redirect-to-https"
#   }
# }



# resource "aws_route53_record" "cdn_cert_validation" {
#   for_each = {
#     for dvo in aws_acm_certificate.cdn_cert.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = data.aws_route53_zone.hosted_zone_id.zone_id
# }



# resource "aws_route53_record" "lookcard_metadata_cdn" {
#   zone_id = data.aws_route53_zone.hosted_zone_id.zone_id
#   name    = "download.${var.environment.domain}"
#   type    = "A"

#   alias {
#     name                   = aws_cloudfront_distribution.lookcard_metadata_cdn.domain_name
#     zone_id                = aws_cloudfront_distribution.lookcard_metadata_cdn.hosted_zone_id
#     evaluate_target_health = false
#   }
# }
