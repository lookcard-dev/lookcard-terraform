provider "aws" {
  alias  = "east"
  region = "us-east-1"
}

variable "aws_provider" {}

variable "domain" {}
variable "storage" {}
variable "security" {}
variable "reseller_portal_hostname" {}
variable "s3_bucket" {}
