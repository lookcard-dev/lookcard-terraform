resource "aws_api_gateway_rest_api" "webhook" {
  name        = "webhook"
  description = ""
}

resource "aws_api_gateway_domain_name" "webhook" {
  domain_name              = var.acm.webhook.domain_name
  certificate_arn = var.acm.webhook.cert_arn
  endpoint_configuration {
    types = ["EDGE"]
  }
}
# resource "aws_api_gateway_vpc_link" "webhook_nlb_vpc_link" {
#   name        = "webhook-nlb-vpc-link"
#   target_arns = [var.application.nlb.arn]

#   tags = {
#     Name = "nlb-vpc-link"
#   }
# }

resource "aws_api_gateway_resource" "webhook_resources" {
  for_each = toset(var.api_gw_resource)
  rest_api_id = aws_api_gateway_rest_api.webhook.id
  parent_id   = aws_api_gateway_rest_api.webhook.root_resource_id
  path_part   = each.value
}

resource "aws_api_gateway_method" "webhook_root_resources_method" {
  for_each = { for pair in setproduct(var.api_gw_resource, var.root_resource_methods) : "${pair[0]}/${pair[1]}" => pair }

  rest_api_id   = aws_api_gateway_rest_api.webhook.id
  resource_id   = aws_api_gateway_resource.webhook_resources[each.value[0]].id
  http_method   = each.value[1]
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "webhook_sumsub_integration" {
  rest_api_id             = aws_api_gateway_rest_api.webhook.id
  resource_id             = aws_api_gateway_resource.webhook_resources["sumsub"].id
  http_method             = aws_api_gateway_method.webhook_root_resources_method["sumsub/POST"].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.application.lambda_function_sumsub_webhook.invoke_arn
}

resource "aws_api_gateway_stage" "webhook" {
  deployment_id = aws_api_gateway_deployment.webhook.id
  rest_api_id   = aws_api_gateway_rest_api.webhook.id
  stage_name    = var.env_tag
  variables = {
    "env" = var.env_tag
  }
  xray_tracing_enabled = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.webhook.arn
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

resource "aws_api_gateway_deployment" "webhook" {
  rest_api_id = aws_api_gateway_rest_api.webhook.id
  
  stage_description = "${md5(file("${path.module}/apigw.tf"))}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_base_path_mapping" "webhook" {
  domain_name = aws_api_gateway_domain_name.webhook.domain_name
  api_id      = aws_api_gateway_rest_api.webhook.id
  stage_name  = var.env_tag
}

# resource "aws_api_gateway_integration" "webhook_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.webhook.id
#   resource_id             = aws_api_gateway_resource.webhook_resources["sumsub"].id
#   http_method             = aws_api_gateway_method.webhook_root_resources_method["sumsub/POST"].http_method
#   type                    = "HTTP_PROXY"
#   integration_http_method = "ANY"
#   uri                     = "http://${var.application.alb_lookcard.dns_name}/{proxy}"
#   connection_type         = "VPC_LINK"
#   connection_id           = "m9jmdj"
#   # request_parameters = {
#   #   "integration.request.path.proxy" = "method.request.path.proxy"
#   # }
# }