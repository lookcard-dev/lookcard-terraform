terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [aws.dns]
    }
  }
}

variable "general_domain" {
    type = string
}

variable "admin_domain" {
    type = string
}

data "aws_route53_zone" "general_hosted_zone" {
  provider = aws.dns
  name = var.general_domain
}

data "aws_route53_zone" "admin_hosted_zone" {
  provider = aws.dns
  name = var.admin_domain
}