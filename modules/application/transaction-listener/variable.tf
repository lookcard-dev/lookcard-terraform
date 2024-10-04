
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
variable "database_secret_arn" {}
variable "get_block_secret_arn" {}

variable "image" {
  type = object({
    url = string
    tag = string
  })
}
locals {
  nile-trongrid = {
    name      = "tron-nile-trongrid"
    port      = 8080
    image     = var.image.url
    image_tag = var.image.tag
  }
  nile-getblock = {
    name      = "tron-nile-getblock"
    port      = 8080
    image     = var.image.url
    image_tag = var.image.tag
  }
}
variable "sqs" {}
variable "capacity_provider_ec2_arm64_on_demand" {}
variable "capacity_provider_ec2_amd64_on_demand" {}
variable "rds_aurora_postgresql_writer_endpoint" {}
variable "rds_aurora_postgresql_reader_endpoint" {}
variable "env_tag" {}