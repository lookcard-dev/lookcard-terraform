data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
provider "aws" {
  region = "us-east-1"
}

variable "alternate_domain_name" {}
variable "alternate_reseller_domain_name" {}
variable "origin_s3_bucket" {}
variable "cdn_logging_s3_bucket" {}
#variable "reseller_portal_bucket" {}

variable "domain" {

}

variable "reseller_portal_bucket" {}

variable "ssl_cert" {}

variable "waf_log" {}
