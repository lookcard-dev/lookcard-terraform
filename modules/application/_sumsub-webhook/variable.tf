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
      SENTRY_DSN = "https://450b23821b84a6c32e52351b4b4210e9@o4507299807428608.ingest.de.sentry.io/4508150005891152",
      RUNTIME_ENVIRONMENT = var.env_tag,
      AWS_XRAY_DAEMON_ENDPOINT = "xray.daemon.lookcard.local:2337"
    }
}