resource "aws_api_gateway_resource" "path" {
  count       = var.image_tag == "latest" ? 0 : 1
  rest_api_id = var.api_gateway_id
  parent_id   = var.api_gateway_resource_id
  path_part   = "sumsub"
}

resource "aws_api_gateway_method" "method" {
  count         = var.image_tag == "latest" ? 0 : 1
  rest_api_id   = var.api_gateway_id
  resource_id   = aws_api_gateway_resource.path[0].id
  http_method   = "POST"
  authorization = "NONE"
}


resource "aws_api_gateway_integration" "lambda_root" {
  count                   = var.image_tag == "latest" ? 0 : 1
  rest_api_id             = var.api_gateway_id
  resource_id             = aws_api_gateway_resource.path[0].id
  http_method             = "POST"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.sumsub_webhook[0].invoke_arn
}
