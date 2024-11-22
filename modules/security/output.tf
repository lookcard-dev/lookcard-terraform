# waf
output "portal_waf" {
  value = {
    arn = aws_wafv2_web_acl.portal.arn
  }
}