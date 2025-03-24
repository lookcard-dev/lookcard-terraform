terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.dns]
    }
  }
}

module "vpc" {
  source              = "./vpc"
  network             = var.network
  aws_provider        = var.aws_provider
  runtime_environment = var.runtime_environment
}

module "cloudmap" {
  source = "./cloudmap"
  vpc_id = module.vpc.vpc_id
}

module "bastion_host" {
  source              = "./bastion-host"
  vpc_id              = module.vpc.vpc_id
  runtime_environment = var.runtime_environment
  subnet_ids          = module.vpc.private_subnet_ids
  aws_provider        = var.aws_provider
}

module "elb" {
  source              = "./elb"
  aws_provider        = var.aws_provider
  runtime_environment = var.runtime_environment
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.isolated_subnet_ids
  depends_on          = [module.vpc]
}

module "dns" {
  source = "./dns"
  providers = {
    aws.dns = aws.dns
  }
}

module "api_gateway" {
  source                    = "./api-gateway"
  network_load_balancer_arn = module.elb.composite_network_load_balancer_arn
  depends_on                = [module.elb, module.elb.composite_network_load_balancer_arn]
}
