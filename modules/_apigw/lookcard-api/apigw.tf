resource "aws_api_gateway_rest_api" "lookcard_api" {
  name        = local.rest_api.name
  description = local.rest_api.description
}

resource "aws_api_gateway_domain_name" "lookcard_api" {
  domain_name              = var.acm.domain_api_name
  certificate_arn = var.acm.cert_api_arn 
  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_resource" "lookcard_api_root_proxy_resource" {
  rest_api_id = aws_api_gateway_rest_api.lookcard_api.id
  parent_id   = aws_api_gateway_rest_api.lookcard_api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "lookcard_api_root_proxy_method" {
  rest_api_id   = aws_api_gateway_rest_api.lookcard_api.id
  resource_id   = aws_api_gateway_resource.lookcard_api_root_proxy_resource.id
  http_method   = "ANY"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.lookcard_api_authorizer.id
}

resource "aws_api_gateway_integration" "lookcard_api_root_proxy_resource_integration" {
  rest_api_id             = aws_api_gateway_rest_api.lookcard_api.id
  resource_id             = aws_api_gateway_resource.lookcard_api_root_proxy_resource.id
  http_method             = aws_api_gateway_method.lookcard_api_root_proxy_method.http_method
  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = "http://${var.application.alb_lookcard.dns_name}/{proxy}"
  connection_type         = "VPC_LINK"
  connection_id           = var.nlb_vpc_link.id
}

resource "aws_api_gateway_stage" "lookcard_api" {
  deployment_id = aws_api_gateway_deployment.lookcard_api.id
  rest_api_id   = aws_api_gateway_rest_api.lookcard_api.id
  stage_name    = var.env_tag
  variables = {
    "env" = var.env_tag
  }
  xray_tracing_enabled = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw_logs.arn
    format = jsonencode({
      requestId      = "$context.requestId",
      ip             = "$context.identity.sourceIp",
      caller         = "$context.identity.caller",
      user           = "$context.identity.user",
      requestTime    = "$context.requestTime",
      httpMethod     = "$context.httpMethod",
      resourcePath   = "$context.resourcePath",
      status         = "$context.status",
      protocol       = "$context.protocol",
      responseLength = "$context.responseLength"
    })
  }
}

resource "aws_api_gateway_deployment" "lookcard_api" {
  rest_api_id = aws_api_gateway_rest_api.lookcard_api.id
  
  stage_description = "${md5(file("${path.module}/apigw.tf"))}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_base_path_mapping" "lookcard_api" {
  domain_name = aws_api_gateway_domain_name.lookcard_api.domain_name
  api_id      = aws_api_gateway_rest_api.lookcard_api.id
  stage_name  = var.env_tag
}

resource "aws_api_gateway_authorizer" "lookcard_api_authorizer" {
  name                   = "lookcard_api_firebase_authorizer"
  rest_api_id            = aws_api_gateway_rest_api.lookcard_api.id
  authorizer_uri         = var.application.lambda_function_firebase_authorizer.invoke_arn
  authorizer_credentials = var.firebase_authorizer_invocation_role.arn
}