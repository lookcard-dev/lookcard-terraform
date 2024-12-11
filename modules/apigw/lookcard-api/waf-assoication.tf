resource "aws_wafv2_web_acl_association" "apigw_lookcard_api" {
  resource_arn = aws_api_gateway_stage.lookcard_api.arn
  web_acl_arn  = var.security_module.api_waf.arn
}
