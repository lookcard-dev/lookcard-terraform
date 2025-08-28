# CloudFront VPC Origin for private ALB
resource "aws_cloudfront_vpc_origin" "web_app_vpc_origin" {
  vpc_origin_endpoint_config {
    name                   = "${var.name}-private-alb"
    arn                    = var.elb.application_load_balancer_arn
    http_port              = 80
    https_port             = 443
    origin_protocol_policy = "http-only" # ALB handles HTTP internally

    origin_ssl_protocols {
      quantity = 1
      items    = ["TLSv1.2"]
    }
  }

  tags = {
    Name        = "${var.name}-vpc-origin"
    Environment = var.runtime_environment
    Service     = "web-app"
  }
}

# Cache Policy for Next.js SSR
resource "aws_cloudfront_cache_policy" "nextjs_ssr" {
  name    = "${var.name}-nextjs-ssr-cache-policy"
  comment = "Cache policy optimized for Next.js SSR applications"

  default_ttl = 0        # No default caching for SSR
  max_ttl     = 31536000 # 1 year max
  min_ttl     = 0

  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true

    cookies_config {
      cookie_behavior = "whitelist"
      cookies {
        items = [
          "next-auth.session-token",
          "next-auth.callback-url",
          "next-auth.csrf-token",
          "__Secure-next-auth.session-token"
        ]
      }
    }

    headers_config {
      header_behavior = "whitelist"
      headers {
        items = [
          "Authorization",
          "CloudFront-Viewer-Country",
          "CloudFront-Is-Mobile-Viewer",
          "Accept-Language",
          "Accept",
          "Origin",
          "Referer"
        ]
      }
    }

    query_strings_config {
      query_string_behavior = "all"
    }
  }

}

# Origin Request Policy
# resource "aws_cloudfront_origin_request_policy" "web_app" {
#   name    = "${var.name}-origin-request-policy"
#   comment = "Origin request policy for Next.js web application"

#   cookies_config {
#     cookie_behavior = "all"
#   }

#   headers_config {
#     header_behavior = "whitelist"
#     headers {
#       items = [
#         "Accept",
#         "Accept-Language", 
#         "CloudFront-Viewer-Country",
#         "CloudFront-Is-Mobile-Viewer",
#         "Origin",
#         "Referer",
#         "User-Agent",
#         "X-Forwarded-Host",
#         "X-Forwarded-Proto",
#         "Host"
#       ]
#     }
#   }

#   query_strings_config {
#     query_string_behavior = "all"
#   }

# }

# Response Headers Policy for Security
# resource "aws_cloudfront_response_headers_policy" "web_app_security" {
#   name    = "${var.name}-security-headers"
#   comment = "Security headers for fintech web application"

#   security_headers_config {
#     strict_transport_security {
#       access_control_max_age_sec = 63072000  # 2 years
#       include_subdomains         = true
#       preload                    = true
#       override                   = false
#     }

#     content_security_policy {
#       content_security_policy = join("; ", [
#         "default-src 'self'",
#         "script-src 'self' 'unsafe-inline' 'unsafe-eval' *.lookcard.com *.vercel-analytics.com",
#         "style-src 'self' 'unsafe-inline' fonts.googleapis.com",
#         "font-src 'self' fonts.gstatic.com",
#         "img-src 'self' data: https: blob:",
#         "connect-src 'self' *.lookcard.com wss: *.vercel-analytics.com",
#         "frame-ancestors 'none'",
#         "base-uri 'self'",
#         "form-action 'self'",
#         "object-src 'none'"
#       ])
#       override = false
#     }

#     frame_options {
#       frame_option = "DENY"
#       override     = false
#     }

#     content_type_options {
#       override = false
#     }

#     referrer_policy {
#       referrer_policy = "strict-origin-when-cross-origin"
#       override        = false
#     }
#   }

#   custom_headers_config {
#     items {
#       header   = "X-Frame-Options"
#       value    = "DENY"
#       override = false
#     }

#     items {
#       header   = "Permissions-Policy"
#       value    = "geolocation=(), microphone=(), camera=(), payment=()"
#       override = false
#     }

#     items {
#       header   = "X-Robots-Tag"
#       value    = "noindex, nofollow, noarchive, nosnippet"
#       override = false
#     }
#   }

# }

# CloudFront Distribution
resource "aws_cloudfront_distribution" "web_app" {
  # Primary origin - VPC Origin for dynamic content
  origin {
    origin_id   = "${var.name}-alb"
    domain_name = var.elb.application_load_balancer_dns_name

    vpc_origin_config {
      vpc_origin_id            = aws_cloudfront_vpc_origin.web_app_vpc_origin.id
      origin_keepalive_timeout = 30 # Keep connections alive longer
      origin_read_timeout      = 60 # Increased timeout for Next.js SSR
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "LookCard Web App Distribution - ${var.runtime_environment}"
  default_root_object = "" # Let Next.js handle routing

  # Domain aliases
  aliases = [
    "app.${var.domain.general.name}"
  ]

  # Default cache behavior for Next.js pages
  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = "${var.name}-alb"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    # Next.js specific cache policy
    cache_policy_id = aws_cloudfront_cache_policy.nextjs_ssr.id

    # Origin request policy for forwarding headers/cookies
    # origin_request_policy_id = aws_cloudfront_origin_request_policy.web_app.id

    # Security headers
    # response_headers_policy_id = aws_cloudfront_response_headers_policy.web_app_security.id

    # Trusted key groups for signed URLs (if needed for premium features)
    trusted_key_groups = []
  }

  # Cache behavior for API routes (bypass cache completely)
  ordered_cache_behavior {
    path_pattern           = "/api/*"
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = "${var.name}-alb"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id = data.aws_cloudfront_cache_policy.caching_disabled.id
    # origin_request_policy_id = aws_cloudfront_origin_request_policy.web_app.id
    # response_headers_policy_id = aws_cloudfront_response_headers_policy.web_app_security.id
  }

  # Cache behavior for Next.js static assets (aggressive caching)
  ordered_cache_behavior {
    path_pattern           = "/_next/static/*"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${var.name}-alb"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id = data.aws_cloudfront_cache_policy.caching_optimized.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.cors_s3_origin.id
  }

  # Cache behavior for public assets (images, fonts, etc.)
  ordered_cache_behavior {
    path_pattern           = "/public/*"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${var.name}-alb"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id          = data.aws_cloudfront_cache_policy.caching_optimized.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.cors_s3_origin.id
  }

  # Geographic restrictions (adjust for fintech compliance)
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # SSL Certificate
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.certificate.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # Logging configuration
  # logging_config {
  #   bucket          = "${var.aws_provider.account_id}-log.s3.amazonaws.com"
  #   prefix          = "cloudfront/${var.name}/"
  #   include_cookies = false
  # }

  tags = {
    Name        = "${var.name}-distribution"
    Environment = var.runtime_environment
    Service     = "web-app"
  }

  depends_on = [
    aws_cloudfront_vpc_origin.web_app_vpc_origin,
    aws_acm_certificate.certificate
  ]
}

# Data sources for managed policies
data "aws_cloudfront_cache_policy" "caching_disabled" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_origin_request_policy" "cors_s3_origin" {
  name = "Managed-CORS-S3Origin"
}
