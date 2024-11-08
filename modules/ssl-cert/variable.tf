variable "domain" {}
variable "app_hostname" {}
variable "admin_hostname" {}
variable "api_hostname" {}
variable "sumsub_webhook_hostname" {}

provider "aws" {
  alias  = "east"
  region = "us-east-1"
}


data "aws_route53_zone" "hosted_zone_id" {
  name = var.domain
}
