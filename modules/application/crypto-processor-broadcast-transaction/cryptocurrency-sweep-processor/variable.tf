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
  lambda_function = {
    name = "Crypto_Processor-Broadcast_Transaction"
    architectures = ["x86_64"]
    package_type = "Image"
    timeout = 900
    memory_size = 512
    tracing_mode = "Active"
  }
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
    var.secret_manager.secret_arns["COINRANKING"],
    var.secret_manager.secret_arns["ELLIPTIC"],
    var.secret_manager.secret_arns["SYSTEM_CRYPTO_WALLET"]
  ]
  sqs_queues = [
    var.sqs.notification_dispatcher.arn
  ]
}
