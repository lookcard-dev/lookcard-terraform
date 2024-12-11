resource "aws_wafv2_web_acl_association" "api_gateway_waf_association" {
  resource_arn = aws_api_gateway_stage.reseller_api.arn
  web_acl_arn  = var.security_module.api_waf.arn
}
