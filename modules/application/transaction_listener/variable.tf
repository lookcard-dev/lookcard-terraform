
variable "vpc_id" {}

variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}
variable "cluster" {}

variable "aggregator_tron_sqs_url" {}
variable "dynamodb_crypto_transaction_listener_arn" {}
variable "aggregator_tron_sqs_arn" {}
variable "secret_manager" {}