output "portal_waf" {
  value = {
    arn = aws_wafv2_web_acl.portal.arn
  }
}

output "api_waf" {
  value = {
    arn = aws_wafv2_web_acl.api.arn
  }
}

output "webhook_waf" {
  value = {
    arn = aws_wafv2_web_acl.webhook.arn
  }
}
