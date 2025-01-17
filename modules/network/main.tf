module "vpc" {
  source = "./vpc"
  network = var.network
  aws_provider = var.aws_provider
}

module "cloudmap"{
  source = "./cloudmap"
  vpc_id = module.vpc.vpc_id
}

# module "elb"{
#   source = "./elb"
#   aws_provider = var.aws_provider
#   runtime_environment = var.runtime_environment
#   vpc_id = module.vpc.vpc_id
#   subnet_ids = module.vpc.isolated_subnet_ids
# }
