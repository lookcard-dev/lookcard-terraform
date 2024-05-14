provider "aws" {
  region = "us-east-1"
}
variable "app_hostname_cert" {}
variable "alternate_domain_name" {}
variable "origin_s3_bucket" {}
variable "cdn_logging_s3_bucket" {}