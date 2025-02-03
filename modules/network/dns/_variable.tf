terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [aws.dns]
    }
  }
}

data "aws_route53_zone" "lookcard_dev" {
  provider = aws.dns
  name = "lookcard.dev"
}

data "aws_route53_zone" "lookcard_org" {
  provider = aws.dns
  name = "lookcard.org"
}
