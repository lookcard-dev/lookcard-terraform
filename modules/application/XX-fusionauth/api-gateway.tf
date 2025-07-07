resource "aws_api_gateway_rest_api" "rest_api" {
  name        = "fusionauth"
  description = "API Gateway for FusionAuth"

  endpoint_configuration {
    types = ["EDGE"]
  }
}

# Create /admin resource to block admin paths
resource "aws_api_gateway_resource" "admin_path" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "admin"
}

# Create /admin/* proxy resource to catch all admin sub-paths
resource "aws_api_gateway_resource" "admin_proxy" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_resource.admin_path.id
  path_part   = "{proxy+}"
}

# Create /api resource for API management routes
resource "aws_api_gateway_resource" "api_path" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "api"
}

# Block /api/system/* - System management APIs
resource "aws_api_gateway_resource" "api_system_path" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_resource.api_path.id
  path_part   = "system"
}

resource "aws_api_gateway_resource" "api_system_proxy" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_resource.api_system_path.id
  path_part   = "{proxy+}"
}

# Block /api/application/* - Application management APIs
resource "aws_api_gateway_resource" "api_application_path" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_resource.api_path.id
  path_part   = "application"
}

resource "aws_api_gateway_resource" "api_application_proxy" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_resource.api_application_path.id
  path_part   = "{proxy+}"
}

# Block /api/tenant/* - Tenant management APIs
resource "aws_api_gateway_resource" "api_tenant_path" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_resource.api_path.id
  path_part   = "tenant"
}

resource "aws_api_gateway_resource" "api_tenant_proxy" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_resource.api_tenant_path.id
  path_part   = "{proxy+}"
}

# Block /api/key/* - Key management APIs
resource "aws_api_gateway_resource" "api_key_path" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_resource.api_path.id
  path_part   = "key"
}

resource "aws_api_gateway_resource" "api_key_proxy" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_resource.api_key_path.id
  path_part   = "{proxy+}"
}

# Block /api/lambda/* - Lambda management APIs
resource "aws_api_gateway_resource" "api_lambda_path" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_resource.api_path.id
  path_part   = "lambda"
}

resource "aws_api_gateway_resource" "api_lambda_proxy" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_resource.api_lambda_path.id
  path_part   = "{proxy+}"
}

# Block /api/webhook/* - Webhook management APIs
resource "aws_api_gateway_resource" "api_webhook_path" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_resource.api_path.id
  path_part   = "webhook"
}

resource "aws_api_gateway_resource" "api_webhook_proxy" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_resource.api_webhook_path.id
  path_part   = "{proxy+}"
}

# Block /admin with 403 Forbidden
resource "aws_api_gateway_method" "admin_block" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.admin_path.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Block /admin/* with 403 Forbidden
resource "aws_api_gateway_method" "admin_proxy_block" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.admin_proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Block /api/system/* with 403 Forbidden
resource "aws_api_gateway_method" "api_system_block" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.api_system_path.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "api_system_proxy_block" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.api_system_proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Block /api/application/* with 403 Forbidden
resource "aws_api_gateway_method" "api_application_block" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.api_application_path.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "api_application_proxy_block" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.api_application_proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Block /api/tenant/* with 403 Forbidden
resource "aws_api_gateway_method" "api_tenant_block" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.api_tenant_path.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "api_tenant_proxy_block" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.api_tenant_proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Block /api/key/* with 403 Forbidden
resource "aws_api_gateway_method" "api_key_block" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.api_key_path.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "api_key_proxy_block" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.api_key_proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Block /api/lambda/* with 403 Forbidden
resource "aws_api_gateway_method" "api_lambda_block" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.api_lambda_path.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "api_lambda_proxy_block" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.api_lambda_proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Block /api/webhook/* with 403 Forbidden
resource "aws_api_gateway_method" "api_webhook_block" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.api_webhook_path.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "api_webhook_proxy_block" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.api_webhook_proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Mock integration for /admin (returns 403)
resource "aws_api_gateway_integration" "admin_block_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.admin_path.id
  http_method = aws_api_gateway_method.admin_block.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 403
    })
  }
}

# Mock integration for /admin/* (returns 403)
resource "aws_api_gateway_integration" "admin_proxy_block_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.admin_proxy.id
  http_method = aws_api_gateway_method.admin_proxy_block.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 403
    })
  }
}

# Mock integrations for /api/system/*
resource "aws_api_gateway_integration" "api_system_block_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.api_system_path.id
  http_method = aws_api_gateway_method.api_system_block.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 403
    })
  }
}

resource "aws_api_gateway_integration" "api_system_proxy_block_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.api_system_proxy.id
  http_method = aws_api_gateway_method.api_system_proxy_block.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 403
    })
  }
}

# Mock integrations for /api/application/*
resource "aws_api_gateway_integration" "api_application_block_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.api_application_path.id
  http_method = aws_api_gateway_method.api_application_block.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 403
    })
  }
}

resource "aws_api_gateway_integration" "api_application_proxy_block_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.api_application_proxy.id
  http_method = aws_api_gateway_method.api_application_proxy_block.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 403
    })
  }
}

# Mock integrations for /api/tenant/*
resource "aws_api_gateway_integration" "api_tenant_block_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.api_tenant_path.id
  http_method = aws_api_gateway_method.api_tenant_block.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 403
    })
  }
}

resource "aws_api_gateway_integration" "api_tenant_proxy_block_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.api_tenant_proxy.id
  http_method = aws_api_gateway_method.api_tenant_proxy_block.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 403
    })
  }
}

# Mock integrations for /api/key/*
resource "aws_api_gateway_integration" "api_key_block_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.api_key_path.id
  http_method = aws_api_gateway_method.api_key_block.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 403
    })
  }
}

resource "aws_api_gateway_integration" "api_key_proxy_block_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.api_key_proxy.id
  http_method = aws_api_gateway_method.api_key_proxy_block.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 403
    })
  }
}

# Mock integrations for /api/lambda/*
resource "aws_api_gateway_integration" "api_lambda_block_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.api_lambda_path.id
  http_method = aws_api_gateway_method.api_lambda_block.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 403
    })
  }
}

resource "aws_api_gateway_integration" "api_lambda_proxy_block_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.api_lambda_proxy.id
  http_method = aws_api_gateway_method.api_lambda_proxy_block.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 403
    })
  }
}

# Mock integrations for /api/webhook/*
resource "aws_api_gateway_integration" "api_webhook_block_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.api_webhook_path.id
  http_method = aws_api_gateway_method.api_webhook_block.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 403
    })
  }
}

resource "aws_api_gateway_integration" "api_webhook_proxy_block_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.api_webhook_proxy.id
  http_method = aws_api_gateway_method.api_webhook_proxy_block.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 403
    })
  }
}

# Method response for /admin (403)
resource "aws_api_gateway_method_response" "admin_block_response" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.admin_path.id
  http_method = aws_api_gateway_method.admin_block.http_method
  status_code = "403"
}

# Method response for /admin/* (403)
resource "aws_api_gateway_method_response" "admin_proxy_block_response" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.admin_proxy.id
  http_method = aws_api_gateway_method.admin_proxy_block.http_method
  status_code = "403"
}

# Integration response for /admin (403)
resource "aws_api_gateway_integration_response" "admin_block_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.admin_path.id
  http_method = aws_api_gateway_method.admin_block.http_method
  status_code = "403"

  response_templates = {
    "application/json" = jsonencode({
      message = "Access to admin paths is forbidden"
    })
  }

  depends_on = [
    aws_api_gateway_method_response.admin_block_response,
    aws_api_gateway_integration.admin_block_integration
  ]
}

# Integration response for /admin/* (403)
resource "aws_api_gateway_integration_response" "admin_proxy_block_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.admin_proxy.id
  http_method = aws_api_gateway_method.admin_proxy_block.http_method
  status_code = "403"

  response_templates = {
    "application/json" = jsonencode({
      message = "Access to admin paths is forbidden"
    })
  }

  depends_on = [
    aws_api_gateway_method_response.admin_proxy_block_response,
    aws_api_gateway_integration.admin_proxy_block_integration
  ]
}

# Create catch-all proxy resource for everything else
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "{proxy+}"
}

# Catch-all method for root path
resource "aws_api_gateway_method" "root_proxy" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

# Catch-all method for all other paths
resource "aws_api_gateway_method" "proxy_method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Integration for root path (proxy to FusionAuth)
resource "aws_api_gateway_integration" "root_proxy_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_rest_api.rest_api.root_resource_id
  http_method             = aws_api_gateway_method.root_proxy.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  connection_type         = "VPC_LINK"
  connection_id           = var.api_gateway.vpc_link_id
  uri                     = "http://auth.${var.domain.general.name}/"
}

# Integration for all other paths (proxy to FusionAuth)
resource "aws_api_gateway_integration" "proxy_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.proxy.id
  http_method             = aws_api_gateway_method.proxy_method.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  connection_type         = "VPC_LINK"
  connection_id           = var.api_gateway.vpc_link_id
  uri                     = "http://auth.${var.domain.general.name}/{proxy}"
}

# Deploy the API
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

  depends_on = [
    aws_api_gateway_integration.admin_block_integration,
    aws_api_gateway_integration.admin_proxy_block_integration,
    aws_api_gateway_integration.root_proxy_integration,
    aws_api_gateway_integration.proxy_integration,
    aws_api_gateway_integration_response.admin_block_integration_response,
    aws_api_gateway_integration_response.admin_proxy_block_integration_response
  ]

  lifecycle {
    create_before_destroy = true
  }

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.admin_path.id,
      aws_api_gateway_resource.admin_proxy.id,
      aws_api_gateway_resource.proxy.id,
      aws_api_gateway_method.admin_block.id,
      aws_api_gateway_method.admin_proxy_block.id,
      aws_api_gateway_method.root_proxy.id,
      aws_api_gateway_method.proxy_method.id,
      aws_api_gateway_integration.admin_block_integration.id,
      aws_api_gateway_integration.admin_proxy_block_integration.id,
      aws_api_gateway_integration.root_proxy_integration.id,
      aws_api_gateway_integration.proxy_integration.id,
    ]))
  }
}

# Create a custom domain name for API Gateway
resource "aws_api_gateway_domain_name" "domain" {
  domain_name     = "auth.${var.domain.general.name}"
  certificate_arn = aws_acm_certificate.certificate.arn

  depends_on = [
    aws_acm_certificate.certificate,
    aws_acm_certificate_validation.certificate_validation
  ]
}

# Map the custom domain to the API Gateway stage
resource "aws_api_gateway_base_path_mapping" "mapping" {
  api_id      = aws_api_gateway_rest_api.rest_api.id
  stage_name  = aws_api_gateway_stage.stage.stage_name
  domain_name = aws_api_gateway_domain_name.domain.domain_name
  depends_on = [
    aws_api_gateway_domain_name.domain,
    aws_api_gateway_stage.stage
  ]
}

# Create stage
resource "aws_api_gateway_stage" "stage" {
  deployment_id        = aws_api_gateway_deployment.deployment.id
  rest_api_id          = aws_api_gateway_rest_api.rest_api.id
  stage_name           = var.runtime_environment
  xray_tracing_enabled = true
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_access_log.arn
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
    aws_cloudwatch_log_group.api_access_log,
  ]
}

resource "aws_api_gateway_method_settings" "api" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = aws_api_gateway_stage.stage.stage_name
  method_path = "*/*"
  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}
