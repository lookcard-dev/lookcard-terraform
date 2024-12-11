variable "acm" {}
variable "env_tag" {}
variable "application" {}
variable "dns_config" {}
variable "domain" {}
variable "nlb_vpc_link" {}
variable "firebase_authorizer_invocation_role" {}
variable "security_module" {}

locals {
  rest_api = {
    name = "lookcard_api"
    description = ""
  }
  cloudwatch_log_group = {
    name = "/aws/api-gateway/lookcard-api"
    retention_in_days = 30
  }
}