# Define the API Gateway
resource "aws_api_gateway_rest_api" "lookcard_api" {
  name        = "lookcard_api"
  description = "lookcard API Gateway pointing to ALB"
}

# Create a Custom Domain
resource "aws_api_gateway_domain_name" "lookcard_domain" {
  domain_name              = "api.test.lookcard.io"
  regional_certificate_arn = "arn:aws:acm:ap-southeast-1:576293270682:certificate/a7e0e210-7f3b-4549-a91e-8f750bea51fd" # Ensure this certificate is in the same region as your API Gateway
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_route53_record" "lookcard_api_record" {
  zone_id    = data.aws_route53_zone.hosted_zone_id.zone_id
  name       = var.dns_config.api_hostname
  type       = "A"

  alias {
    name                   = aws_api_gateway_domain_name.lookcard_domain.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.lookcard_domain.regional_zone_id
    evaluate_target_health = false
  }
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



resource "aws_api_gateway_deployment" "lookcard_deployment" {
  depends_on = [
    aws_api_gateway_integration.lookcard_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.lookcard_api.id
  stage_name  = "prod"
}

resource "aws_api_gateway_base_path_mapping" "lookcard_mapping" {
  domain_name = aws_api_gateway_domain_name.lookcard_domain.domain_name
  api_id      = aws_api_gateway_rest_api.lookcard_api.id
  stage_name  = aws_api_gateway_deployment.lookcard_deployment.stage_name
}
