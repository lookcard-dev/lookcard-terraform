resource "aws_api_gateway_rest_api" "webhook_api" {
  name        = "webhook-api"
  description = "API Gateway for Webhook"

  endpoint_configuration {
    types = ["EDGE"]
  }
}

# Create resources for each specific path
resource "aws_api_gateway_resource" "sumsub_path" {
  rest_api_id = aws_api_gateway_rest_api.webhook_api.id
  parent_id   = aws_api_gateway_rest_api.webhook_api.root_resource_id
  path_part   = "sumsub"
}

resource "aws_api_gateway_resource" "reap_path" {
  rest_api_id = aws_api_gateway_rest_api.webhook_api.id
  parent_id   = aws_api_gateway_rest_api.webhook_api.root_resource_id
  path_part   = "reap"
}

resource "aws_api_gateway_resource" "firebase_path" {
  rest_api_id = aws_api_gateway_rest_api.webhook_api.id
  parent_id   = aws_api_gateway_rest_api.webhook_api.root_resource_id
  path_part   = "firebase"
}

# Set up POST method for /sumsub
resource "aws_api_gateway_method" "sumsub_post" {
  rest_api_id   = aws_api_gateway_rest_api.webhook_api.id
  resource_id   = aws_api_gateway_resource.sumsub_path.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "sumsub_integration" {
  rest_api_id             = aws_api_gateway_rest_api.webhook_api.id
  resource_id             = aws_api_gateway_resource.sumsub_path.id
  http_method             = aws_api_gateway_method.sumsub_post.http_method
  integration_http_method = "POST"
  type                    = "HTTP_PROXY"
  connection_type         = "VPC_LINK"
  connection_id           = var.api_gateway.vpc_link_id
  uri                     = "http://${var.elb.network_load_balancer_dns_name}/sumsub"
}

# Set up POST method for /reap
resource "aws_api_gateway_method" "reap_post" {
  rest_api_id   = aws_api_gateway_rest_api.webhook_api.id
  resource_id   = aws_api_gateway_resource.reap_path.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "reap_integration" {
  rest_api_id             = aws_api_gateway_rest_api.webhook_api.id
  resource_id             = aws_api_gateway_resource.reap_path.id
  http_method             = aws_api_gateway_method.reap_post.http_method
  integration_http_method = "POST"
  type                    = "HTTP_PROXY"
  connection_type         = "VPC_LINK"
  connection_id           = var.api_gateway.vpc_link_id
  uri                     = "http://${var.elb.network_load_balancer_dns_name}/reap"
}

# Set up POST method for /firebase
resource "aws_api_gateway_method" "firebase_post" {
  rest_api_id   = aws_api_gateway_rest_api.webhook_api.id
  resource_id   = aws_api_gateway_resource.firebase_path.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "firebase_integration" {
  rest_api_id             = aws_api_gateway_rest_api.webhook_api.id
  resource_id             = aws_api_gateway_resource.firebase_path.id
  http_method             = aws_api_gateway_method.firebase_post.http_method
  integration_http_method = "POST"
  type                    = "HTTP_PROXY"
  connection_type         = "VPC_LINK"
  connection_id           = var.api_gateway.vpc_link_id
  uri                     = "http://${var.elb.network_load_balancer_dns_name}/firebase"
}

# Add OPTIONS method for CORS support on each path
resource "aws_api_gateway_method" "sumsub_options" {
  rest_api_id   = aws_api_gateway_rest_api.webhook_api.id
  resource_id   = aws_api_gateway_resource.sumsub_path.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "reap_options" {
  rest_api_id   = aws_api_gateway_rest_api.webhook_api.id
  resource_id   = aws_api_gateway_resource.reap_path.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "firebase_options" {
  rest_api_id   = aws_api_gateway_rest_api.webhook_api.id
  resource_id   = aws_api_gateway_resource.firebase_path.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# Deploy the API Gateway
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.webhook_api.id

  depends_on = [
    aws_api_gateway_integration.sumsub_integration,
    aws_api_gateway_integration.reap_integration,
    aws_api_gateway_integration.firebase_integration
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
