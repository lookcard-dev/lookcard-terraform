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
  domain = var.domain
  
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

module "iam" {
  source = "./iam"
  runtime_environment = var.runtime_environment
  aws_provider = var.aws_provider
}