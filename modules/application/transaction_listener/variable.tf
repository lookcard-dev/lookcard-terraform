
variable "vpc_id" {}

variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}
variable "cluster" {}

variable "dynamodb_crypto_transaction_listener_arn" {}
variable "secret_manager" {}
variable "trongrid_secret_arn" {}
variable "image" {
  type = object({
    url = string
    tag = string
  })
}
locals {
  application = {
    name      = "Transaction-Listener-1"
    port      = 8080
    image     = var.image.url
    image_tag = var.image.tag
  }
}
variable "sqs" {}