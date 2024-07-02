
variable "secret_names" {
  type = list(string)
  default = [
    "firebase", //過!
    "tron", //過!
    "reap", //過!
    "wallet", // 棄用!
    "elliptic", //過!
    "blockchain", // 棄用!
    "sumsub", //過!
    "twilio",//過!
    "sendgrid",//過!
    "crypto-api-worker-wallet",// 改名叫SYSTEM_CRYPTO_WALLET
    "env",//      //過!
    "token",//      // TOKEN
    "db/secret",
    "aml_env",//evvo
    "crypto-api-env",//
    "notification-env",//
    "coinranking",
    "aggregator-env",//
    "did-processor/lambda",//
    "look-card_db_master_password",//

//* 以下是新secret manager */
    //one2cloud
    "REAP",
    "TRONGRID",
    "FIREBASE",
    "SUMSUB",
    "ELLIPTIC",
    "HAWK",
    "SYSTEM_CRYPTO_WALLET",
    "TWILIO",
    "SENDGRID",
    "COINRANKING",
    // evvo lab 
    "ENV",
    "TOKEN", //
    "DATABASE",
    "AML_ENV",
    "CRYPTO_API_ENV",
    "NOTIFICATION_ENV",
    "AGGREGATOR_ENV",
    "DID_PROCESSOR_LAMBDA",
    "DB_MASTER_PASSWORD"
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