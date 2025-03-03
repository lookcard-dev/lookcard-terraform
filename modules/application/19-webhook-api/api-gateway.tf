resource "aws_api_gateway_rest_api" "webhook_api" {
  name        = "webhook-api"
  description = "API Gateway for Webhook"

  endpoint_configuration {
    types = ["EDGE"]
  }
}

# Handle the root path as well
resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = aws_api_gateway_rest_api.webhook_api.id
  resource_id   = aws_api_gateway_rest_api.webhook_api.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "proxy_root_integration" {
  rest_api_id          = aws_api_gateway_rest_api.webhook_api.id
  resource_id          = aws_api_gateway_rest_api.webhook_api.root_resource_id
  http_method          = aws_api_gateway_method.proxy_root.http_method
  type                 = "MOCK"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200,
      message    = "Welcome to the webhook API"
    })
  }
}

# Create a proper method response for the ANY method
resource "aws_api_gateway_method_response" "proxy_root_response" {
  rest_api_id = aws_api_gateway_rest_api.webhook_api.id
  resource_id = aws_api_gateway_rest_api.webhook_api.root_resource_id
  http_method = aws_api_gateway_method.proxy_root.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "proxy_root_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.webhook_api.id
  resource_id = aws_api_gateway_rest_api.webhook_api.root_resource_id
  http_method = aws_api_gateway_method.proxy_root.http_method
  status_code = aws_api_gateway_method_response.proxy_root_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT,DELETE'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  response_templates = {
    "application/json" = jsonencode({
      message = "Welcome to the webhook API"
    })
  }
}

# Deploy the API Gateway
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.webhook_api.id

  depends_on = [
    aws_api_gateway_integration.proxy_root_integration
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# Create a custom domain name for API Gateway
resource "aws_api_gateway_domain_name" "webhook_domain" {
  domain_name     = "webhook.${var.general_domain}"
  certificate_arn = aws_acm_certificate.certificate.arn

  depends_on = [
    aws_acm_certificate.certificate,
    aws_acm_certificate_validation.certificate_validation
  ]
}

# Map the custom domain to the API Gateway stage
resource "aws_api_gateway_base_path_mapping" "webhook_mapping" {
  api_id      = aws_api_gateway_rest_api.webhook_api.id
  stage_name  = aws_api_gateway_stage.stage.stage_name
  domain_name = aws_api_gateway_domain_name.webhook_domain.domain_name
  depends_on = [
    aws_api_gateway_domain_name.webhook_domain,
    aws_api_gateway_stage.stage
  ]
}

# Fix existing issues in the stage resource
resource "aws_api_gateway_stage" "stage" {
  deployment_id        = aws_api_gateway_deployment.deployment.id
  rest_api_id          = aws_api_gateway_rest_api.webhook_api.id
  stage_name           = var.runtime_environment
  xray_tracing_enabled = true
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.webhook_api_access_log.arn
    format = jsonencode({
      requestId       = "$context.requestId"
      userSub         = "$context.authorizer.claims.sub"
      ip              = "$context.identity.sourceIp"
      method          = "$context.httpMethod"
      path            = "$context.path"
      status          = "$context.status"
      responseLength  = "$context.responseLength"
      responseLatency = "$context.responseLatency"
    })
  }
  depends_on = [
    aws_api_gateway_deployment.deployment,
    aws_cloudwatch_log_group.webhook_api_access_log,
  ]
}

resource "aws_api_gateway_method_settings" "webhook_api" {
  rest_api_id = aws_api_gateway_rest_api.webhook_api.id
  stage_name  = aws_api_gateway_stage.stage.stage_name
  method_path = "*/*"
  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}
