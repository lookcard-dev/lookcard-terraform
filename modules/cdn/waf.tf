

resource "aws_wafv2_web_acl" "cdn_waf" {
  name  = "cdn_waf_rule"
  scope = "CLOUDFRONT"
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
        limit                 = 4000
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

  # Rule for Bot Control
  rule {
    name     = "BotControl"
    priority = 3
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesBotControlRuleSet"
        managed_rule_group_configs {
          aws_managed_rules_bot_control_rule_set {
            inspection_level = "TARGETED"
          }

        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BotControl-metric"
      sampled_requests_enabled   = true
    }
  }

  # Rule for Core Rule Set
  rule {
    name     = "CoreRuleSet"
    priority = 4
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesCommonRuleSet"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CoreRuleSet-metric"
      sampled_requests_enabled   = true
    }
  }

  # Rule for SQL Injection Protection
  rule {
    name     = "SQLInjectionProtection"
    priority = 5
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesSQLiRuleSet"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "SQLInjectionProtection-metric"
      sampled_requests_enabled   = true
    }
  }



  # Rule for Amazon IP Reputation List
  rule {
    name     = "AmazonIPReputationList"
    priority = 7
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



resource "aws_wafv2_web_acl" "portal" {
  name  = "portal"
  scope = "CLOUDFRONT"
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


