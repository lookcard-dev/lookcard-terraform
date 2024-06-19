variable "default_listener" {}
variable "vpc_id" {}
variable "lookcard_notification_sqs_url" {}
variable "crypto_fund_withdrawal_sqs_url" {}
variable "lookcardlocal_namespace_id" {}
variable "cluster" {}

variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}

variable "secret_arns" {
  description = "List of ARN for Secrets Manager"
  type        = list(string)
}

variable "crypto_api_secret_arn" {}

variable "firebase_secret_arn" {}

variable "elliptic_secret_arn" {}

variable "db_secret_secret_arn" {}