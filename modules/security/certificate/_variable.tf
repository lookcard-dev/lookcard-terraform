provider "aws" {
  alias  = "east"
  region = "us-east-1"
}

variable "general_domain" {
    type = string
}

variable "admin_domain" {
    type = string
}

data "aws_route53_zone" "general_hosted_zone" {
  name = var.general_domain
}

data "aws_route53_zone" "admin_hosted_zone" {
  name = var.admin_domain
}