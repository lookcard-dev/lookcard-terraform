terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [aws.dns]
    }
  }
}

variable "domain" {
  type = object({
    general = object({
      name = string
      zone_id = string
    })
    admin = object({
      name = string
      zone_id = string
    })
  })
}

data "aws_route53_zone" "general_hosted_zone" {
  provider = aws.dns
  name = var.domain.general.name
  zone_id = var.domain.general.zone_id
}

data "aws_route53_zone" "admin_hosted_zone" {
  provider = aws.dns
  name = var.domain.admin.name
  zone_id = var.domain.admin.zone_id  
}