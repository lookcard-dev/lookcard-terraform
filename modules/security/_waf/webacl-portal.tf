resource "aws_wafv2_web_acl" "portal" {
  provider = aws.us_east_1
  name     = "portal"
  scope    = "CLOUDFRONT"
  default_action {
    allow {

    }
  }
  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "cdn-rule-metric"
    sampled_requests_enabled   = true
  }
  rule {
    name     = "rate-limit"
    priority = 0
    action {
      block {}
    }
    statement {
      rate_based_statement {
        limit                 = 5000
        aggregate_key_type    = "IP"
        evaluation_window_sec = 60
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "rate-limit"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AmazonIPReputationList"
    priority = 1
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesAmazonIpReputationList"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AmazonIPReputationList-metric"
      sampled_requests_enabled   = true
    }
  }
}

resource "aws_wafv2_web_acl_logging_configuration" "portal" {
  provider                = aws.us_east_1
  log_destination_configs = [var.waf_logging_s3_bucket]
  resource_arn            = aws_wafv2_web_acl.portal.arn
}