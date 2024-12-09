output "reseller_api_domain_name" {
  value = aws_api_gateway_domain_name.reseller_api.domain_name
}

output "reseller_api_stage" {
  value = {
    arn = aws_api_gateway_stage.reseller_api.arn
  }
}