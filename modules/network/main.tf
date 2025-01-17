module "vpc" {
  source = "./vpc"
  network = var.network
  aws_provider = var.aws_provider
}

module "cloudmap"{
  source = "./cloudmap"
  vpc_id = module.vpc.vpc_id
}