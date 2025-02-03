terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [aws.dns]
    }
  }
}

module "certificate" {
  source = "./certificate"
  general_domain = var.general_domain
  admin_domain = var.admin_domain
  
  providers = {
    aws.dns = aws.dns
  }
}

module "kms" {
  source = "./kms"
}

module "secret" {
  source = "./secret"
}