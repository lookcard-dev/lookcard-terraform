variable "acm" {}
variable "env_tag" {}
variable "application" {}
variable "dns_config" {}
variable "domain" {}
variable "nlb_vpc_link" {}
variable "firebase_authorizer_invocation_role" {}
variable "security_module" {}

variable "methods" {
  type    = list(string)
  default = ["GET", "POST", "PUT"]  # List of HTTP methods
}

variable "reseller_api_root_resource" {
  type    = list(string)
  default = ["reseller", "resellers", "tier", "tiers"]
}

variable "reseller_api_proxy_resource" {
  type    = list(string)
  default = ["reseller", "resellers"]
}

variable "reseller_api_resellers_resource" {
  type    = list(string)
  default = ["tier", "tiers", "{proxy+}"]
}

locals {
  rest_api = {
    name = "reseller_api"
    description = ""
  }
  cloudwatch_log_group = {
    name = "/aws/api-gateway/reseller-api"
    retention_in_days = 30
  }
}