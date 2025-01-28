resource "aws_api_gateway_rest_api" "api" {
  name        = var.name
}

# resource "aws_api_gateway_domain_name" "domain" {
#   domain_name              = "api.reseller"
#   certificate_arn = var.acm.reseller_api.cert_arn 
#   endpoint_configuration {
#     types = ["EDGE"]
#   }
# }

resource "aws_api_gateway_resource" "default_resource" {
  depends_on = [ aws_api_gateway_rest_api.api ] 
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "default_resource_method" {
  depends_on = [ aws_api_gateway_rest_api.api, aws_api_gateway_resource.default_resource ]
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.default_resource.id
  http_method = "ANY"
  authorization = "NONE"
}