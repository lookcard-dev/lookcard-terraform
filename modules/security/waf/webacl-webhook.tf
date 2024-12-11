resource "aws_wafv2_web_acl" "webhook" {
  name  = "webhook"
  scope = "REGIONAL"
  default_action {
    allow {

    }
  }
  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "webhook-rule-metric"
    sampled_requests_enabled   = true
  }
}
