resource "aws_api_gateway_rest_api" "supabase_api" {
  name        = "supabase-api"
  description = "API Gateway for Supabase Services via Kong"

  endpoint_configuration {
    types = ["EDGE"]
  }
}

# Create a catch-all proxy resource
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.supabase_api.id
  parent_id   = aws_api_gateway_rest_api.supabase_api.root_resource_id
  path_part   = "{proxy+}"
}

# ANY method for the proxy resource
resource "aws_api_gateway_method" "proxy_any" {
  rest_api_id   = aws_api_gateway_rest_api.supabase_api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Integration to route all traffic through Kong via ALB
resource "aws_api_gateway_integration" "proxy_integration" {
  rest_api_id             = aws_api_gateway_rest_api.supabase_api.id
  resource_id             = aws_api_gateway_resource.proxy.id
  http_method             = aws_api_gateway_method.proxy_any.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  connection_type         = "VPC_LINK"
  connection_id           = var.api_gateway.vpc_link_id
  uri                     = "http://supabase.${var.domain.general.name}/{proxy}"
}

# Root resource method for requests to /
resource "aws_api_gateway_method" "root_any" {
  rest_api_id   = aws_api_gateway_rest_api.supabase_api.id
  resource_id   = aws_api_gateway_rest_api.supabase_api.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "root_integration" {
  rest_api_id             = aws_api_gateway_rest_api.supabase_api.id
  resource_id             = aws_api_gateway_rest_api.supabase_api.root_resource_id
  http_method             = aws_api_gateway_method.root_any.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  connection_type         = "VPC_LINK"
  connection_id           = var.api_gateway.vpc_link_id
  uri                     = "http://supabase.${var.domain.general.name}/"
}

# CORS support for proxy
resource "aws_api_gateway_method" "proxy_options" {
  rest_api_id   = aws_api_gateway_rest_api.supabase_api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "proxy_options_response" {
  rest_api_id = aws_api_gateway_rest_api.supabase_api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration" "proxy_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.supabase_api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy_options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}

resource "aws_api_gateway_integration_response" "proxy_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.supabase_api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,apikey'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method_response.proxy_options_response,
    aws_api_gateway_integration.proxy_options_integration
  ]
}

# CORS support for root
resource "aws_api_gateway_method" "root_options" {
  rest_api_id   = aws_api_gateway_rest_api.supabase_api.id
  resource_id   = aws_api_gateway_rest_api.supabase_api.root_resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "root_options_response" {
  rest_api_id = aws_api_gateway_rest_api.supabase_api.id
  resource_id = aws_api_gateway_rest_api.supabase_api.root_resource_id
  http_method = aws_api_gateway_method.root_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration" "root_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.supabase_api.id
  resource_id = aws_api_gateway_rest_api.supabase_api.root_resource_id
  http_method = aws_api_gateway_method.root_options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}

resource "aws_api_gateway_integration_response" "root_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.supabase_api.id
  resource_id = aws_api_gateway_rest_api.supabase_api.root_resource_id
  http_method = aws_api_gateway_method.root_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,apikey'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method_response.root_options_response,
    aws_api_gateway_integration.root_options_integration
  ]
}

# Deployment
resource "aws_api_gateway_deployment" "supabase_deployment" {
  rest_api_id = aws_api_gateway_rest_api.supabase_api.id

  depends_on = [
    aws_api_gateway_integration.proxy_integration,
    aws_api_gateway_integration.root_integration,
    aws_api_gateway_integration_response.proxy_options_integration_response,
    aws_api_gateway_integration_response.root_options_integration_response,
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# Custom domain
# resource "aws_api_gateway_domain_name" "supabase_domain" {
#   domain_name     = "supabase.${var.domain.general.name}"
#   certificate_arn = aws_acm_certificate.api_certificate.arn

#   endpoint_configuration {
#     types = ["EDGE"]
#   }
# }

# resource "aws_api_gateway_base_path_mapping" "supabase_mapping" {
#   api_id      = aws_api_gateway_rest_api.supabase_api.id
#   stage_name  = aws_api_gateway_stage.supabase_stage.stage_name
#   domain_name = aws_api_gateway_domain_name.supabase_domain.domain_name
# }

resource "aws_api_gateway_stage" "supabase_stage" {
  deployment_id = aws_api_gateway_deployment.supabase_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.supabase_api.id
  stage_name    = "v1"

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.supabase_api_logs.arn
    format = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      caller         = "$context.identity.caller"
      user           = "$context.identity.user"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      resourcePath   = "$context.resourcePath"
      status         = "$context.status"
      protocol       = "$context.protocol"
      responseLength = "$context.responseLength"
    })
  }

  xray_tracing_enabled = true

  tags = {
    Name        = "supabase-api-stage"
    Environment = var.runtime_environment
  }
}


resource "aws_api_gateway_method_settings" "supabase_api" {
  rest_api_id = aws_api_gateway_rest_api.supabase_api.id
  stage_name  = aws_api_gateway_stage.supabase_stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}
