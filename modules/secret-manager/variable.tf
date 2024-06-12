
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
    "crypto-api-worker-wallet",
    "env",
    "token",
    "db/secret",
    "aml_env"

  ]
}

variable "env_secrets" {
  description = "A map of secrets to store in the env secret"
  type        = map(string)
  sensitive   = true
}