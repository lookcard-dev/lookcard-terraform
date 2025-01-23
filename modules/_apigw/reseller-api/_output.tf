output "reseller_api_stage" {
  value = {
    arn = aws_api_gateway_stage.reseller_api.arn
  }
}