variable "acm" {}
variable "env_tag" {}
variable "application" {}
variable "dns_config" {}
variable "domain" {}


variable "api_gw_resource" {
  type = list(string)
  default = [
    # "firebase",
    # "fireblocks",
    # "reap",
    "sumsub"
  ]
}

variable "root_resource_methods" {
  type = list(string)
  default = [
    "POST"
  ]
}

locals {
  rest_api = {
    name = "webhook"
    description = ""
  }
  cloudwatch_log_group = {
    name = "/aws/api-gateway/webhook"
    retention_in_days = 30
  }
}