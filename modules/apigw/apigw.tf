resource "aws_api_gateway_account" "account_settings" {
  cloudwatch_role_arn = aws_iam_role.api_gateway_cloudwatch_role.arn
}

resource "aws_api_gateway_rest_api" "lookcard_api" {
  name        = "lookcard_api"
  description = "lookcard API Gateway pointing to ALB"
}

resource "aws_api_gateway_domain_name" "lookcard_domain" {
  domain_name              = var.acm.domain_api_name
  regional_certificate_arn = var.acm.cert_api_arn # Ensure this certificate is in the same region as your API Gateway
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "lookcard_resource" {
  rest_api_id = aws_api_gateway_rest_api.lookcard_api.id
  parent_id   = aws_api_gateway_rest_api.lookcard_api.root_resource_id
  path_part   = "{proxy+}"
}
# Create a Method
resource "aws_api_gateway_method" "lookcard_method" {
  rest_api_id   = aws_api_gateway_rest_api.lookcard_api.id
  resource_id   = aws_api_gateway_resource.lookcard_resource.id
  http_method   = "ANY"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.firebase_authorizer.id

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_vpc_link" "nlb_vpc_link" {
  name        = "nlb-vpc-link"
  target_arns = [var.application.nlb.arn]

  tags = {
    Name = "nlb-vpc-link"
  }
}

# Create an Integration
resource "aws_api_gateway_integration" "lookcard_integration" {
  rest_api_id             = aws_api_gateway_rest_api.lookcard_api.id
  resource_id             = aws_api_gateway_resource.lookcard_resource.id
  http_method             = aws_api_gateway_method.lookcard_method.http_method
  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = "http://${var.application.alb_lookcard.dns_name}/{proxy}"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.nlb_vpc_link.id
  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "lookcard_deployment" {
  rest_api_id = aws_api_gateway_rest_api.lookcard_api.id
  
  stage_description = "${md5(file("${path.module}/apigw.tf"))}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_base_path_mapping" "base_path_mapping" {
  domain_name = aws_api_gateway_domain_name.lookcard_domain.domain_name
  api_id      = aws_api_gateway_rest_api.lookcard_api.id
  stage_name  = "Develop" #var.env_tag - temp hard code for solve the terraform apply issue
}

# API Gateway Stage with CloudWatch Logs
resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.lookcard_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.lookcard_api.id
  stage_name    = "Develop" #var.env_tag <- temp hard code for solve the terraform apply issue 
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

resource "aws_api_gateway_authorizer" "firebase_authorizer" {
  name                   = "firebase_authorizer"
  rest_api_id            = aws_api_gateway_rest_api.lookcard_api.id
  authorizer_uri         = var.application.lambda_function_firebase_authorizer.invoke_arn
  authorizer_credentials = aws_iam_role.api_gateway_firebase_invocation_role.arn
}