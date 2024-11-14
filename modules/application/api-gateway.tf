# IAM Role for API Gateway to write logs to CloudWatch
resource "aws_iam_role" "api_gateway_cloudwatch_role" {
  name = "APIGatewayCloudWatchLogsRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "apigateway.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "api_gateway_cloudwatch_policy" {
  name = "APIGatewayCloudWatchLogsPolicy"
  role = aws_iam_role.api_gateway_cloudwatch_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ],
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# API Gateway Account Settings
resource "aws_api_gateway_account" "account_settings" {
  cloudwatch_role_arn = aws_iam_role.api_gateway_cloudwatch_role.arn
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "api_gw_logs" {
  name              = "/aws/api-gateway/lookcard"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "sumsub_webhook" {
  name              = "/aws/api-gateway/sumsub_webhook"
  retention_in_days = 30
}

# Define the API Gateway
resource "aws_api_gateway_rest_api" "lookcard_api" {
  name        = "lookcard_api"
  description = "lookcard API Gateway pointing to ALB"
}

resource "aws_api_gateway_rest_api" "sumsub_webhook" {
  name        = "sumsub_webhook"
  description = ""
}

resource "aws_api_gateway_rest_api" "reap_webhook" {
  name        = "reap_webhook"
  description = ""
}

resource "aws_api_gateway_rest_api" "firebase_webhook" {
  name        = "firebase_webhook"
  description = ""
}

resource "aws_api_gateway_rest_api" "fireblocks_webhook" {
  name        = "fireblocks_webhook"
  description = ""
}

# Create a Custom Domain
resource "aws_api_gateway_domain_name" "lookcard_domain" {
  domain_name              = var.acm.domain_api_name
  regional_certificate_arn = var.acm.cert_api_arn # Ensure this certificate is in the same region as your API Gateway
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_domain_name" "sumsub_webhook" {
  domain_name              = var.acm.sumsub_webhook.domain_name
  regional_certificate_arn = var.acm.sumsub_webhook.cert_arn # Ensure this certificate is in the same region as your API Gateway
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_domain_name" "reap_webhook" {
  domain_name              = var.acm.reap_webhook.domain_name
  regional_certificate_arn = var.acm.reap_webhook.cert_arn # Ensure this certificate is in the same region as your API Gateway
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_domain_name" "firebase_webhook" {
  domain_name              = var.acm.firebase_webhook.domain_name
  regional_certificate_arn = var.acm.firebase_webhook.cert_arn # Ensure this certificate is in the same region as your API Gateway
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_domain_name" "fireblocks_webhook" {
  domain_name              = var.acm.fireblocks_webhook.domain_name
  regional_certificate_arn = var.acm.fireblocks_webhook.cert_arn # Ensure this certificate is in the same region as your API Gateway
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_route53_record" "lookcard_api_record" {
  zone_id = data.aws_route53_zone.hosted_zone_id.zone_id
  name    = var.dns_config.api_hostname
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.lookcard_domain.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.lookcard_domain.regional_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "sumsub_webhook" {
  zone_id = data.aws_route53_zone.hosted_zone_id.zone_id
  name    = var.dns_config.sumsub_webhook_hostname
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.sumsub_webhook.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.sumsub_webhook.regional_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "reap_webhook" {
  zone_id = data.aws_route53_zone.hosted_zone_id.zone_id
  name    = var.dns_config.reap_webhook_hostname
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.reap_webhook.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.reap_webhook.regional_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "firebase_webhook" {
  zone_id = data.aws_route53_zone.hosted_zone_id.zone_id
  name    = var.dns_config.firebase_webhook_hostname
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.firebase_webhook.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.firebase_webhook.regional_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "fireblocks_webhook" {
  zone_id = data.aws_route53_zone.hosted_zone_id.zone_id
  name    = var.dns_config.fireblocks_webhook_hostname
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.fireblocks_webhook.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.fireblocks_webhook.regional_zone_id
    evaluate_target_health = false
  }
}

# Create a Resource
resource "aws_api_gateway_resource" "lookcard_resource" {
  rest_api_id = aws_api_gateway_rest_api.lookcard_api.id
  parent_id   = aws_api_gateway_rest_api.lookcard_api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_resource" "sumsub_webhook" {
  rest_api_id = aws_api_gateway_rest_api.sumsub_webhook.id
  parent_id   = aws_api_gateway_rest_api.sumsub_webhook.root_resource_id
  path_part   = "webhook"
}

resource "aws_api_gateway_resource" "reap_webhook" {
  rest_api_id = aws_api_gateway_rest_api.reap_webhook.id
  parent_id   = aws_api_gateway_rest_api.reap_webhook.root_resource_id
  path_part   = "webhook"
}

resource "aws_api_gateway_resource" "firebase_webhook" {
  rest_api_id = aws_api_gateway_rest_api.firebase_webhook.id
  parent_id   = aws_api_gateway_rest_api.firebase_webhook.root_resource_id
  path_part   = "webhook"
}

resource "aws_api_gateway_resource" "fireblocks_webhook" {
  rest_api_id = aws_api_gateway_rest_api.fireblocks_webhook.id
  parent_id   = aws_api_gateway_rest_api.fireblocks_webhook.root_resource_id
  path_part   = "webhook"
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

resource "aws_api_gateway_method" "sumsub_webhook" {
  rest_api_id   = aws_api_gateway_rest_api.sumsub_webhook.id
  resource_id   = aws_api_gateway_resource.sumsub_webhook.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "reap_webhook" {
  rest_api_id   = aws_api_gateway_rest_api.reap_webhook.id
  resource_id   = aws_api_gateway_resource.reap_webhook.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "firebase_webhook" {
  rest_api_id   = aws_api_gateway_rest_api.firebase_webhook.id
  resource_id   = aws_api_gateway_resource.firebase_webhook.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "fireblocks_webhook" {
  rest_api_id   = aws_api_gateway_rest_api.fireblocks_webhook.id
  resource_id   = aws_api_gateway_resource.fireblocks_webhook.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_vpc_link" "nlb_vpc_link" {
  name        = "nlb-vpc-link"
  target_arns = [aws_lb.nlb.arn]

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
  uri                     = "http://${aws_alb.look-card.dns_name}/{proxy}"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.nlb_vpc_link.id
  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_integration" "sumsub_webhook" {
  rest_api_id             = aws_api_gateway_rest_api.sumsub_webhook.id
  resource_id             = aws_api_gateway_resource.sumsub_webhook.id
  http_method             = aws_api_gateway_method.sumsub_webhook.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda.sumsub_webhook.invoke_arn
}

resource "aws_api_gateway_deployment" "lookcard_deployment" {
  depends_on = [
    aws_api_gateway_integration.lookcard_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.lookcard_api.id
}

resource "aws_api_gateway_base_path_mapping" "base_path_mapping" {
  domain_name = aws_api_gateway_domain_name.lookcard_domain.domain_name
  api_id      = aws_api_gateway_rest_api.lookcard_api.id
  stage_name  = var.env_tag
}

# API Gateway Stage with CloudWatch Logs
resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.lookcard_deployment.id
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

resource "aws_api_gateway_stage" "sumsub_webhook" {
  deployment_id = aws_api_gateway_deployment.sumsub_webhook.id
  rest_api_id   = aws_api_gateway_rest_api.sumsub_webhook.id
  stage_name    = var.env_tag
  variables = {
    "env" = var.env_tag
  }
  xray_tracing_enabled = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.sumsub_webhook.arn
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

resource "aws_api_gateway_deployment" "sumsub_webhook" {
  depends_on = [
    aws_api_gateway_integration.sumsub_webhook,
    aws_api_gateway_rest_api.sumsub_webhook
  ]

  rest_api_id = aws_api_gateway_rest_api.sumsub_webhook.id
}

//* Push_message_Web api_gw
resource "aws_apigatewayv2_api" "Push_message_Web" {
  name                       = "Push_message_Web"
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}

resource "aws_apigatewayv2_integration" "push_message_integration" {
  api_id                    = aws_apigatewayv2_api.Push_message_Web.id
  integration_type          = "AWS_PROXY"
  content_handling_strategy = "CONVERT_TO_TEXT"
  integration_uri           = var.lambda.lookcard_websocket_arn
  integration_method        = "POST"
}

resource "aws_apigatewayv2_route" "push_message_route" {
  api_id    = aws_apigatewayv2_api.Push_message_Web.id
  route_key = "POST /pushmessage"
  target    = "integrations/${aws_apigatewayv2_integration.push_message_integration.id}"
}

resource "aws_lambda_permission" "apigateway_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda.lookcard_websocket_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.Push_message_Web.execution_arn}/*"
}
resource "aws_apigatewayv2_integration" "connect_integration" {
  api_id                    = aws_apigatewayv2_api.Push_message_Web.id
  integration_type          = "AWS_PROXY"
  content_handling_strategy = "CONVERT_TO_TEXT"
  description               = "Connection"
  connection_type           = "INTERNET"
  integration_method        = "POST"
  integration_uri           = var.lambda.websocket_connect_arn
}

resource "aws_apigatewayv2_route" "connect" {
  route_key = "$connect"
  api_id    = aws_apigatewayv2_api.Push_message_Web.id
  target    = "integrations/${aws_apigatewayv2_integration.connect_integration.id}"
}

resource "aws_lambda_permission" "web_socket_apigateway_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda.websocket_connect_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.Push_message_Web.execution_arn}/*"
}

resource "aws_apigatewayv2_integration" "disconnect_integration" {
  api_id                    = aws_apigatewayv2_api.Push_message_Web.id
  integration_type          = "AWS"
  connection_type           = "INTERNET"
  content_handling_strategy = "CONVERT_TO_TEXT"
  integration_method        = "POST"
  integration_uri           = var.lambda.websocket_disconnect_arn
  passthrough_behavior      = "WHEN_NO_MATCH"
}
resource "aws_apigatewayv2_route" "disconnect_route" {
  route_key = "$disconnect"
  api_id    = aws_apigatewayv2_api.Push_message_Web.id
  target    = "integrations/${aws_apigatewayv2_integration.disconnect_integration.id}"
}

resource "aws_lambda_permission" "web_disconnect_apigateway_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda.websocket_disconnect_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.Push_message_Web.execution_arn}/*"
}


resource "aws_api_gateway_authorizer" "firebase_authorizer" {
  name                   = "firebase_authorizer"
  rest_api_id            = aws_api_gateway_rest_api.lookcard_api.id
  authorizer_uri         = var.lambda_firebase_authorizer.invoke_arn
  authorizer_credentials = aws_iam_role.api_gateway_firebase_invocation_role.arn
}

resource "aws_iam_role" "api_gateway_firebase_invocation_role" {
  name = "api-gateway-firebase-invocation-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
          "Service" : "apigateway.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "api_gateway_firebase_invocation_policy" {
  name        = "apigateway-firebase-invocation-policy"
  description = "Allows api gateway to invoke Firebase_Authorizer Lambda function"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "lambda:InvokeFunction"
        ],
        "Resource" : [
          var.lambda_firebase_authorizer.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "api_gateway_firebase_invocation_role_attachment" {
  role       = aws_iam_role.api_gateway_firebase_invocation_role.name
  policy_arn = aws_iam_policy.api_gateway_firebase_invocation_policy.arn
}