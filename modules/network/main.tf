module "vpc" {
  source              = "./vpc"
  network             = var.network
  aws_provider        = var.aws_provider
  runtime_environment = var.runtime_environment
}

module "cloudmap" {
  source     = "./cloudmap"
  vpc_id     = module.vpc.vpc_id
  depends_on = [module.vpc]
}

module "bastion_host" {
  source              = "./bastion-host"
  vpc_id              = module.vpc.vpc_id
  runtime_environment = var.runtime_environment
  subnet_ids          = module.vpc.private_subnet_ids
  aws_provider        = var.aws_provider
  depends_on          = [module.vpc]
}

module "elb" {
  source                         = "./elb"
  aws_provider                   = var.aws_provider
  runtime_environment            = var.runtime_environment
  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.isolated_subnet_ids
  bastion_host_security_group_id = module.bastion_host.bastion_host_security_group_id
  depends_on                     = [module.vpc]
}

module "api_gateway" {
  source                    = "./api-gateway"
  network_load_balancer_arn = module.elb.network_load_balancer_arn
  depends_on                = [module.elb]
}
