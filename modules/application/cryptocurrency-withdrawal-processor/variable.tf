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

variable "sqs" {}
variable "secret_manager" {}
locals {
    lambda_env_vars = {
      "CRYPTO_API_PROTOCOL"             = "http"
      "CRYPTO_API_HOST"                 = "crypto.api.lookcard.local"
      "CRYPTO_API_PORT"                 = 8080
      "ACCOUNT_API_PROTOCOL"            = "http"
      "ACCOUNT_API_HOST"                = "account.api.lookcard.local"
      "ACCOUNT_API_PORT"                = 8080
    }

    secrets = [
      var.secret_manager.secret_arns["ELLIPTIC"],
      var.secret_manager.secret_arns["SYSTEM_CRYPTO_WALLET"]
    ]

    sqs_queues = [
      var.sqs.cryptocurrency_withdrawal.arn
    ]
}