resource "aws_api_gateway_account" "account_settings" {
  cloudwatch_role_arn = aws_iam_role.api_gateway_cloudwatch_role.arn
}

resource "aws_api_gateway_rest_api" "lookcard_api" {
  name        = "lookcard_api"
  description = "lookcard API Gateway pointing to ALB"
}

# resource "aws_api_gateway_rest_api" "webhook" {
#   name        = "webhook"
#   description = ""
# }

resource "aws_api_gateway_rest_api" "reseller_api" {
  name        = "reseller_api"
  description = ""
}

resource "aws_api_gateway_domain_name" "lookcard_domain" {
  domain_name              = var.acm.domain_api_name
  regional_certificate_arn = var.acm.cert_api_arn # Ensure this certificate is in the same region as your API Gateway
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# resource "aws_api_gateway_domain_name" "sumsub_webhook" {
#   domain_name              = var.acm.sumsub_webhook.domain_name
#   certificate_arn = var.acm.sumsub_webhook.cert_arn
#   endpoint_configuration {
#     types = ["EDGE"]
#   }
# }

# resource "aws_api_gateway_domain_name" "reap_webhook" {
#   domain_name              = var.acm.reap_webhook.domain_name
#   certificate_arn = var.acm.reap_webhook.cert_arn # Ensure this certificate is in the same region as your API Gateway
#   endpoint_configuration {
#     types = ["EDGE"]
#   }
# }

# resource "aws_api_gateway_domain_name" "firebase_webhook" {
#   domain_name              = var.acm.firebase_webhook.domain_name
#   certificate_arn = var.acm.firebase_webhook.cert_arn # Ensure this certificate is in the same region as your API Gateway
#   endpoint_configuration {
#     types = ["EDGE"]
#   }
# }

# resource "aws_api_gateway_domain_name" "fireblocks_webhook" {
#   domain_name              = var.acm.fireblocks_webhook.domain_name
#   certificate_arn = var.acm.fireblocks_webhook.cert_arn # Ensure this certificate is in the same region as your API Gateway
#   endpoint_configuration {
#     types = ["EDGE"]
#   }
# }

resource "aws_api_gateway_domain_name" "reseller_api" {
  domain_name              = var.acm.reseller_api.domain_name
  certificate_arn = var.acm.reseller_api.cert_arn 
  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_resource" "lookcard_resource" {
  rest_api_id = aws_api_gateway_rest_api.lookcard_api.id
  parent_id   = aws_api_gateway_rest_api.lookcard_api.root_resource_id
  path_part   = "{proxy+}"
}

# resource "aws_api_gateway_resource" "sumsub_webhook" {
#   rest_api_id = aws_api_gateway_rest_api.webhook.id
#   parent_id   = aws_api_gateway_rest_api.webhook.root_resource_id
#   path_part   = "sumsub"
# }

# resource "aws_api_gateway_resource" "reap_webhook" {
#   rest_api_id = aws_api_gateway_rest_api.webhook.id
#   parent_id   = aws_api_gateway_rest_api.webhook.root_resource_id
#   path_part   = "reap"
# }

# resource "aws_api_gateway_resource" "firebase_webhook" {
#   rest_api_id = aws_api_gateway_rest_api.webhook.id
#   parent_id   = aws_api_gateway_rest_api.webhook.root_resource_id
#   path_part   = "firebase"
# }

# resource "aws_api_gateway_resource" "fireblocks_webhook" {
#   rest_api_id = aws_api_gateway_rest_api.webhook.id
#   parent_id   = aws_api_gateway_rest_api.webhook.root_resource_id
#   path_part   = "fireblocks"
# }

resource "aws_api_gateway_resource" "reseller_api_root_resource" {
  for_each = toset(var.reseller_api_root_resource)

  rest_api_id = aws_api_gateway_rest_api.reseller_api.id
  parent_id   = aws_api_gateway_rest_api.reseller_api.root_resource_id
  path_part   = each.key
}

resource "aws_api_gateway_resource" "reseller_api_reseller_proxy_resource" {
  rest_api_id = aws_api_gateway_rest_api.reseller_api.id
  parent_id   = aws_api_gateway_resource.reseller_api_root_resource["reseller"].id
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

# resource "aws_api_gateway_method" "sumsub_webhook" {
#   rest_api_id   = aws_api_gateway_rest_api.webhook.id
#   resource_id   = aws_api_gateway_resource.sumsub_webhook.id
#   http_method   = "POST"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_method" "reap_webhook" {
#   rest_api_id   = aws_api_gateway_rest_api.webhook.id
#   resource_id   = aws_api_gateway_resource.reap_webhook.id
#   http_method   = "POST"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_method" "firebase_webhook" {
#   rest_api_id   = aws_api_gateway_rest_api.webhook.id
#   resource_id   = aws_api_gateway_resource.firebase_webhook.id
#   http_method   = "POST"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_method" "fireblocks_webhook" {
#   rest_api_id   = aws_api_gateway_rest_api.webhook.id
#   resource_id   = aws_api_gateway_resource.fireblocks_webhook.id
#   http_method   = "POST"
#   authorization = "NONE"
# }

resource "aws_api_gateway_method" "reseller_api_root_resource_method" {
  for_each = { for pair in setproduct(var.reseller_api_root_resource, var.methods) : "${pair[0]}/${pair[1]}" => pair }

  rest_api_id   = aws_api_gateway_rest_api.reseller_api.id
  resource_id   = aws_api_gateway_resource.reseller_api_root_resource[each.value[0]].id
  http_method   = each.value[1]
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.reseller_api_authorizer.id
}

resource "aws_api_gateway_method" "reseller_api_reseller_proxy_method" {
  for_each = toset(var.methods)
  rest_api_id   = aws_api_gateway_rest_api.reseller_api.id
  resource_id   = aws_api_gateway_resource.reseller_api_reseller_proxy_resource.id
  http_method   = each.key
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.reseller_api_authorizer.id
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

# resource "aws_api_gateway_integration" "sumsub_webhook" {
#   rest_api_id             = aws_api_gateway_rest_api.webhook.id
#   resource_id             = aws_api_gateway_resource.sumsub_webhook.id
#   http_method             = aws_api_gateway_method.sumsub_webhook.http_method
#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = var.application.lambda_function_sumsub_webhook.invoke_arn
# }

resource "aws_api_gateway_integration" "reseller_api_root_resource_integration" {
  for_each = { for pair in setproduct(var.reseller_api_root_resource, var.methods) : "${pair[0]}/${pair[1]}" => pair }

  rest_api_id             = aws_api_gateway_rest_api.reseller_api.id
  resource_id             = aws_api_gateway_resource.reseller_api_root_resource[each.value[0]].id
  http_method             = each.value[1]
  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = "http://${var.application.alb_lookcard.dns_name}/{proxy}"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.nlb_vpc_link.id
}

resource "aws_api_gateway_integration" "reseller_api_reseller_proxy_resource_integration" {
  for_each = toset(var.methods)

  rest_api_id             = aws_api_gateway_rest_api.reseller_api.id
  resource_id             = aws_api_gateway_resource.reseller_api_reseller_proxy_resource.id
  http_method             = each.key
  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = "http://${var.application.alb_lookcard.dns_name}/{proxy}"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.nlb_vpc_link.id
}

resource "aws_api_gateway_deployment" "lookcard_deployment" {
  rest_api_id = aws_api_gateway_rest_api.lookcard_api.id
  
  stage_description = "${md5(file("${path.module}/apigw.tf"))}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_deployment" "reseller_api" {
  rest_api_id = aws_api_gateway_rest_api.reseller_api.id
  
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

resource "aws_api_gateway_base_path_mapping" "reseller_api" {
  domain_name = aws_api_gateway_domain_name.reseller_api.domain_name
  api_id      = aws_api_gateway_rest_api.reseller_api.id
  stage_name  = var.env_tag
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

resource "aws_api_gateway_stage" "reseller_api" {
  deployment_id = aws_api_gateway_deployment.reseller_api.id
  rest_api_id   = aws_api_gateway_rest_api.reseller_api.id
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


resource "aws_api_gateway_authorizer" "firebase_authorizer" {
  name                   = "firebase_authorizer"
  rest_api_id            = aws_api_gateway_rest_api.lookcard_api.id
  authorizer_uri         = var.application.lambda_function_firebase_authorizer.invoke_arn
  authorizer_credentials = aws_iam_role.api_gateway_firebase_invocation_role.arn
}

resource "aws_api_gateway_authorizer" "reseller_api_authorizer" {
  name                   = "reseller_api_firebase_authorizer"
  rest_api_id            = aws_api_gateway_rest_api.reseller_api.id
  authorizer_uri         = var.application.lambda_function_firebase_authorizer.invoke_arn
  authorizer_credentials = aws_iam_role.api_gateway_firebase_invocation_role.arn
}