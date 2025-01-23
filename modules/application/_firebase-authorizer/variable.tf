variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}

variable "image" {
  type = object({
    url = string
    tag = string
  })
}

variable "env_tag" {}

locals {
    lambda_env_vars = {
      "SENTRY_DSN"                      = "https://a6dd019878e8998d0117d8f298cbce5f@o4507299807428608.ingest.de.sentry.io/4508289701052496"
      "RUNTIME_ENVIRONMENT"             = var.env_tag
      "AWS_XRAY_DAEMON_ENDPOINT"        = "xray.daemon.lookcard.local:2337"
    }
    inbound_allow_sg_list = [
      
    ]
}