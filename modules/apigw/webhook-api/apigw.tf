resource "aws_api_gateway_rest_api" "webhook" {
  name        = "webhook"
  description = ""
}

resource "aws_api_gateway_domain_name" "sumsub_webhook" {
  domain_name              = var.acm.sumsub_webhook.domain_name
  certificate_arn = var.acm.sumsub_webhook.cert_arn
  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_domain_name" "reap_webhook" {
  domain_name              = var.acm.reap_webhook.domain_name
  certificate_arn = var.acm.reap_webhook.cert_arn # Ensure this certificate is in the same region as your API Gateway
  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_domain_name" "firebase_webhook" {
  domain_name              = var.acm.firebase_webhook.domain_name
  certificate_arn = var.acm.firebase_webhook.cert_arn # Ensure this certificate is in the same region as your API Gateway
  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_domain_name" "fireblocks_webhook" {
  domain_name              = var.acm.fireblocks_webhook.domain_name
  certificate_arn = var.acm.fireblocks_webhook.cert_arn # Ensure this certificate is in the same region as your API Gateway
  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_resource" "sumsub_webhook" {
  rest_api_id = aws_api_gateway_rest_api.webhook.id
  parent_id   = aws_api_gateway_rest_api.webhook.root_resource_id
  path_part   = "sumsub"
}

resource "aws_api_gateway_resource" "reap_webhook" {
  rest_api_id = aws_api_gateway_rest_api.webhook.id
  parent_id   = aws_api_gateway_rest_api.webhook.root_resource_id
  path_part   = "reap"
}

resource "aws_api_gateway_resource" "firebase_webhook" {
  rest_api_id = aws_api_gateway_rest_api.webhook.id
  parent_id   = aws_api_gateway_rest_api.webhook.root_resource_id
  path_part   = "firebase"
}

resource "aws_api_gateway_resource" "fireblocks_webhook" {
  rest_api_id = aws_api_gateway_rest_api.webhook.id
  parent_id   = aws_api_gateway_rest_api.webhook.root_resource_id
  path_part   = "fireblocks"
}

resource "aws_api_gateway_method" "sumsub_webhook" {
  rest_api_id   = aws_api_gateway_rest_api.webhook.id
  resource_id   = aws_api_gateway_resource.sumsub_webhook.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "reap_webhook" {
  rest_api_id   = aws_api_gateway_rest_api.webhook.id
  resource_id   = aws_api_gateway_resource.reap_webhook.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "firebase_webhook" {
  rest_api_id   = aws_api_gateway_rest_api.webhook.id
  resource_id   = aws_api_gateway_resource.firebase_webhook.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "fireblocks_webhook" {
  rest_api_id   = aws_api_gateway_rest_api.webhook.id
  resource_id   = aws_api_gateway_resource.fireblocks_webhook.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "sumsub_webhook" {
  rest_api_id             = aws_api_gateway_rest_api.webhook.id
  resource_id             = aws_api_gateway_resource.sumsub_webhook.id
  http_method             = aws_api_gateway_method.sumsub_webhook.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.application.lambda_function_sumsub_webhook.invoke_arn
}