# module "lookcard-api" {
#   source = "./lookcard-api"
#   env_tag = var.env_tag
#   domain = var.domain
#   dns_config = var.dns_config
# }

module "reseller-api" {
  source = "./reseller-api"
  env_tag = var.env_tag
  domain = var.domain
  dns_config = var.dns_config
  acm = var.acm
  application = var.application
  nlb_vpc_link = aws_api_gateway_vpc_link.nlb_vpc_link
  firebase_authorizer_invocation_role = aws_iam_role.api_gateway_firebase_invocation_role
  security_module = var.security_module
}

module "webhook" {
  source = "./webhook"
  env_tag = var.env_tag
  acm = var.acm
  application = var.application
  domain = var.domain
  dns_config = var.dns_config
  security_module = var.security_module
}
