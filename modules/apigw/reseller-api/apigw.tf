resource "aws_api_gateway_rest_api" "reseller_api" {
  name        = local.rest_api.name
  description = local.rest_api.description
}

resource "aws_api_gateway_domain_name" "reseller_api" {
  domain_name              = var.acm.reseller_api.domain_name
  certificate_arn = var.acm.reseller_api.cert_arn 
  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_resource" "reseller_api_root_resource" {
  depends_on = [ aws_api_gateway_rest_api.reseller_api ]
  for_each = toset(var.reseller_api_root_resource)

  rest_api_id = aws_api_gateway_rest_api.reseller_api.id
  parent_id   = aws_api_gateway_rest_api.reseller_api.root_resource_id
  path_part   = each.key
}

resource "aws_api_gateway_resource" "reseller_api_reseller_proxy_resource" {
  depends_on = [ aws_api_gateway_rest_api.reseller_api ]
  rest_api_id = aws_api_gateway_rest_api.reseller_api.id
  parent_id   = aws_api_gateway_resource.reseller_api_root_resource["reseller"].id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_resource" "reseller_api_resellers_proxy_resource" {
  depends_on = [ aws_api_gateway_rest_api.reseller_api ]
  rest_api_id = aws_api_gateway_rest_api.reseller_api.id
  parent_id   = aws_api_gateway_resource.reseller_api_root_resource["resellers"].id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "reseller_api_root_resource_method" {
  depends_on = [ aws_api_gateway_rest_api.reseller_api, aws_api_gateway_resource.reseller_api_root_resource ]
  for_each = { for pair in setproduct(var.reseller_api_root_resource, var.methods) : "${pair[0]}/${pair[1]}" => pair }

  rest_api_id   = aws_api_gateway_rest_api.reseller_api.id
  resource_id   = aws_api_gateway_resource.reseller_api_root_resource[each.value[0]].id
  http_method   = each.value[1]
  authorization = "NONE" #"CUSTOM"
  # authorizer_id = aws_api_gateway_authorizer.reseller_api_authorizer.id
  request_parameters = {
    "method.request.path.proxy" = true
    "method.request.header.host" = true
  }
}

resource "aws_api_gateway_method" "reseller_api_reseller_proxy_method" {
  depends_on = [ aws_api_gateway_rest_api.reseller_api, aws_api_gateway_resource.reseller_api_reseller_proxy_resource ]
  for_each = toset(var.methods)

  rest_api_id   = aws_api_gateway_rest_api.reseller_api.id
  resource_id   = aws_api_gateway_resource.reseller_api_reseller_proxy_resource.id
  http_method   = each.key
  authorization = "NONE" #"CUSTOM"
  # authorizer_id = aws_api_gateway_authorizer.reseller_api_authorizer.id

  request_parameters = {
    "method.request.path.proxy" = true
    "method.request.header.host" = true
  }
}

resource "aws_api_gateway_method" "reseller_api_resellers_proxy_method" {
  depends_on = [ aws_api_gateway_rest_api.reseller_api, aws_api_gateway_resource.reseller_api_resellers_proxy_resource ]
  for_each = toset(var.methods)

  rest_api_id   = aws_api_gateway_rest_api.reseller_api.id
  resource_id   = aws_api_gateway_resource.reseller_api_resellers_proxy_resource.id
  http_method   = each.key
  authorization = "NONE" #"CUSTOM"
  # authorizer_id = aws_api_gateway_authorizer.reseller_api_authorizer.id

  request_parameters = {
    "method.request.path.proxy" = true
    "method.request.header.host" = true
  }
}

resource "aws_api_gateway_integration" "reseller_api_root_resource_integration" {
  depends_on = [ aws_api_gateway_rest_api.reseller_api, aws_api_gateway_resource.reseller_api_root_resource, aws_api_gateway_method.reseller_api_root_resource_method ]
  for_each = { for pair in setproduct(var.reseller_api_root_resource, var.methods) : "${pair[0]}/${pair[1]}" => {
    resource = pair[0]
    method = pair[1]
  }}

  rest_api_id             = aws_api_gateway_rest_api.reseller_api.id
  resource_id             = aws_api_gateway_resource.reseller_api_root_resource[each.value.resource].id
  http_method             = each.value.method
  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = "http://${var.application.alb_lookcard.dns_name}/${each.value.resource}"
  connection_type         = "VPC_LINK"
  connection_id           = var.nlb_vpc_link.id

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
    "integration.request.header.X-Forwarded-Host" = "method.request.header.host"
  }
}

resource "aws_api_gateway_integration" "reseller_api_reseller_proxy_resource_integration" {
  depends_on = [
    aws_api_gateway_rest_api.reseller_api,
    aws_api_gateway_resource.reseller_api_reseller_proxy_resource,
    aws_api_gateway_method.reseller_api_reseller_proxy_method,
    aws_api_gateway_resource.reseller_api_resellers_proxy_resource
  ]
  for_each = toset(var.methods)

  rest_api_id           = aws_api_gateway_rest_api.reseller_api.id
  resource_id           = aws_api_gateway_resource.reseller_api_reseller_proxy_resource.id
  http_method           = each.key
  type                  = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                   = "http://${var.application.alb_lookcard.dns_name}/reseller/{proxy}"
  connection_type       = "VPC_LINK"
  connection_id         = var.nlb_vpc_link.id
  cache_key_parameters = ["method.request.path.proxy"]
  
  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
    "integration.request.header.X-Forwarded-Host" = "method.request.header.host"
  }
}

resource "aws_api_gateway_integration" "resellers_api_resellers_proxy_resource_integration" {
  depends_on = [
    aws_api_gateway_rest_api.reseller_api,
    aws_api_gateway_resource.reseller_api_resellers_proxy_resource,
    aws_api_gateway_method.reseller_api_resellers_proxy_method
  ]
  for_each = toset(var.methods)

  rest_api_id           = aws_api_gateway_rest_api.reseller_api.id
  resource_id           = aws_api_gateway_resource.reseller_api_resellers_proxy_resource.id
  http_method           = each.key
  type                  = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                   = "http://${var.application.alb_lookcard.dns_name}/resellers/{proxy}"
  connection_type       = "VPC_LINK"
  connection_id         = var.nlb_vpc_link.id
  cache_key_parameters = ["method.request.path.proxy"]
  
  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
    "integration.request.header.X-Forwarded-Host" = "method.request.header.host"
  }
}

resource "aws_api_gateway_stage" "reseller_api" {
  deployment_id = aws_api_gateway_deployment.reseller_api.id
  rest_api_id   = aws_api_gateway_rest_api.reseller_api.id
  stage_name    = var.env_tag
  variables = {
    "env" = var.env_tag
  }
  xray_tracing_enabled = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.reseller_api.arn
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

resource "aws_api_gateway_deployment" "reseller_api" {
  depends_on = [
    aws_api_gateway_method.reseller_api_root_resource_method,
    aws_api_gateway_integration.reseller_api_root_resource_integration,
    aws_api_gateway_method.reseller_api_reseller_proxy_method,
    aws_api_gateway_integration.reseller_api_reseller_proxy_resource_integration,
    aws_api_gateway_method.reseller_api_resellers_proxy_method,
    aws_api_gateway_integration.resellers_api_resellers_proxy_resource_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.reseller_api.id
  
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_method.reseller_api_root_resource_method,
      aws_api_gateway_integration.reseller_api_root_resource_integration,
      aws_api_gateway_method.reseller_api_reseller_proxy_method,
      aws_api_gateway_integration.reseller_api_reseller_proxy_resource_integration,
      aws_api_gateway_method.reseller_api_resellers_proxy_method,
      aws_api_gateway_integration.resellers_api_resellers_proxy_resource_integration
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_base_path_mapping" "reseller_api" {
  depends_on = [ aws_api_gateway_stage.reseller_api ]

  domain_name = aws_api_gateway_domain_name.reseller_api.domain_name
  api_id      = aws_api_gateway_rest_api.reseller_api.id
  stage_name  = var.env_tag
}

resource "aws_api_gateway_authorizer" "reseller_api_authorizer" {
  name                   = "reseller_api_firebase_authorizer"
  rest_api_id            = aws_api_gateway_rest_api.reseller_api.id
  authorizer_uri         = var.application.lambda_function_firebase_authorizer.invoke_arn
  authorizer_credentials = var.firebase_authorizer_invocation_role.arn
}
