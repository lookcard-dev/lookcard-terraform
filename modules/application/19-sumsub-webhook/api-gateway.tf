resource "aws_api_gateway_rest_api" "sumsub_webhook_api" {
  count       = var.image_tag == "latest" ? 0 : 1
  name        = "sumsub-webhook-api"
  description = "API Gateway for Sumsub Webhook Lambda"

  endpoint_configuration {
    types = ["EDGE"]
  }
}

# Create a resource that matches any path - for Express.js proxy integration
resource "aws_api_gateway_resource" "proxy" {
  count       = var.image_tag == "latest" ? 0 : 1
  rest_api_id = aws_api_gateway_rest_api.sumsub_webhook_api[0].id
  parent_id   = aws_api_gateway_rest_api.sumsub_webhook_api[0].root_resource_id
  path_part   = "{proxy+}"
}

# Set up ANY method to handle all HTTP methods
resource "aws_api_gateway_method" "proxy" {
  count         = var.image_tag == "latest" ? 0 : 1
  rest_api_id   = aws_api_gateway_rest_api.sumsub_webhook_api[0].id
  resource_id   = aws_api_gateway_resource.proxy[0].id
  http_method   = "ANY"
  authorization = "NONE"
}

# Set up the Lambda integration
resource "aws_api_gateway_integration" "lambda_integration" {
  count                   = var.image_tag == "latest" ? 0 : 1
  rest_api_id             = aws_api_gateway_rest_api.sumsub_webhook_api[0].id
  resource_id             = aws_api_gateway_resource.proxy[0].id
  http_method             = aws_api_gateway_method.proxy[0].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.sumsub_webhook[0].invoke_arn
}

# Handle the root path as well
resource "aws_api_gateway_method" "proxy_root" {
  count         = var.image_tag == "latest" ? 0 : 1
  rest_api_id   = aws_api_gateway_rest_api.sumsub_webhook_api[0].id
  resource_id   = aws_api_gateway_rest_api.sumsub_webhook_api[0].root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
  count                   = var.image_tag == "latest" ? 0 : 1
  rest_api_id             = aws_api_gateway_rest_api.sumsub_webhook_api[0].id
  resource_id             = aws_api_gateway_rest_api.sumsub_webhook_api[0].root_resource_id
  http_method             = aws_api_gateway_method.proxy_root[0].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.sumsub_webhook[0].invoke_arn
}

# Deploy the API Gateway
resource "aws_api_gateway_deployment" "deployment" {
  count = var.image_tag == "latest" ? 0 : 1
  depends_on = [
    aws_api_gateway_integration.lambda_integration[0],
    aws_api_gateway_integration.lambda_root[0],
  ]

  rest_api_id = aws_api_gateway_rest_api.sumsub_webhook_api[0].id

  lifecycle {
    create_before_destroy = true
  }
}
