
variable "secret_names" {
  type = list(string)
  default = [
    "firebase",
    "tron",
    "reap",
    "wallet",
    "elliptic",
    "blockchain",
    "sumsub",
    "twilio",
    "sendgrid",
    "crypto-api-worker-wallet",//
    "env",//
    "token",//
    "db/secret",
    "aml_env",//evvo
    "crypto-api-env",//
    "notification-env",//
    "coinranking",
    "aggregator-env",//
    "did-processor/lambda",//
    "look-card_db_master_password"//

  ]
}

variable "env_secrets" {
  description = "A map of secrets to store in the env secret"
  type        = map(string)
  sensitive   = true
}

variable "notification_env_secrets" {
  description = "A map of secrets to store in the env secret"
  type        = map(string)
  sensitive   = true
}

variable "tron_secrets" {
  description = "A map of secrets to store in the env secret"
  type        = map(string)
  sensitive   = true
}

variable "coinranking_secrets" {
  description = "A map of secrets to store in the env secret"
  type        = map(string)
  sensitive   = true
}

variable "crypto_api_worker_wallet_secrets" {
  description = "A map of secrets to store in the env secret"
  type        = map(string)
  sensitive   = true
}

variable "elliptic_secrets" {
  description = "A map of secrets to store in the env secret"
  type        = map(string)
  sensitive   = true
}

variable "reap_secrets" {
  description = "A map of secrets to store in the env secret"
  type        = map(string)
  sensitive   = true
}


variable "did_processor_lambda_secrets" {
  description = "A map of secrets to store in the env secret"
  type        = map(string)
  sensitive   = true
}

variable "token_secrets" {
  description = "A map of secrets to store in the env secret"
  type        = map(string)
  sensitive   = true
}

variable "aggregator_env_secrets" {
  description = "A map of secrets to store in the env secret"
  type        = map(string)
  sensitive   = true
}

variable "db_secrets" {
  description = "A map of secrets to store in the env secret"
  type        = map(string)
  sensitive   = true
}

variable "firebase_secrets" {
  description = "A map of secrets to store in the env secret"
  type        = map(string)
  sensitive   = true
}

variable "crypto_api_env_secrets" {
  description = "A map of secrets to store in the env secret"
  type        = map(string)
  sensitive   = true
}


variable "aml_env_secrets" {
  description = "A map of secrets to store in the env secret"
  type        = map(string)
  sensitive   = true
}