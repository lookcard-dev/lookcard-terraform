# Define the API Gateway
resource "aws_api_gateway_rest_api" "lookcard_api" {
  name        = "lookcard_api"
  description = "lookcard API Gateway pointing to ALB"
}

# Create a Resource
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
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

# Create an Integration
resource "aws_api_gateway_integration" "lookcard_integration" {
  rest_api_id             = aws_api_gateway_rest_api.lookcard_api.id
  resource_id             = aws_api_gateway_resource.lookcard_resource.id
  http_method             = aws_api_gateway_method.lookcard_method.http_method
  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = "http://${aws_alb.look-card.dns_name}/{proxy}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

# Create a Custom Domain
resource "aws_api_gateway_domain_name" "lookcard_domain" {
  domain_name     = "api.test.lookcard.io"
  regional_certificate_arn = "arn:aws:acm:ap-southeast-1:576293270682:certificate/a7e0e210-7f3b-4549-a91e-8f750bea51fd" # Ensure this certificate is in the same region as your API Gateway
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}


resource "aws_api_gateway_deployment" "lookcard_deployment" {
  depends_on = [
    aws_api_gateway_integration.lookcard_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.lookcard_api.id
  stage_name  = "prod"
}

