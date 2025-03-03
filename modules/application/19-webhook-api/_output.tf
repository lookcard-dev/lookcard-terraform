output "api_gateway_id" {
  value = aws_api_gateway_rest_api.webhook_api.id
}

output "api_gateway_resource_id" {
  value = aws_api_gateway_rest_api.webhook_api.root_resource_id
}
