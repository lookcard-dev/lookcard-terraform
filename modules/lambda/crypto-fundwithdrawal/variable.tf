variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
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
      "ELLIPTIC_SECRET_ARN"             = "${var.secret_manager.elliptic_secret_arn}"
      "SYSTEM_CRYPTO_WALLET_SECRET_ARN" = "${var.secret_manager.system_crypto_wallet_secret_arn}"
      "SQS_NOTIFICATION_QUEUE_URL"      = var.sqs.lookcard_notification_queue_url
    }
}