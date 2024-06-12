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
