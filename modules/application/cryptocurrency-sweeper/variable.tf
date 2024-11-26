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
      "USER_API_PROTOCOL"               = "http"
      "USER_API_HOST"                   = "_user.api.lookcard.local"
      "USER_API_PORT"                   = 8000
      "ACCOUNT_API_PROTOCOL"            = "http"
      "ACCOUNT_API_HOST"                = "account.api.lookcard.local"
      "ACCOUNT_API_PORT"                = 8080
      "SECRET_MANAGER_NAME"             = "Aggregator-env"     
    }
    secrets = [
      var.secret_manager.coinranking_secret_arn,
      var.secret_manager.elliptic_secret_arn,
      var.secret_manager.system_crypto_wallet_secret_arn
    ]
    sqs_queues = [
      var.sqs.notification_dispatcher.arn
    ]
}
