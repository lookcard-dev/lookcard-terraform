module "s3" {
  source = "./s3"
  
  s3_bucket = var.s3_bucket
  environment = var.environment
  aws_provider = var.aws_provider
}

module "cache" {
  source = "./cache"
  network = {
    vpc            = var.network.vpc
    private_subnet = var.network.private_subnet
    public_subnet  = var.network.public_subnet
    database_subnet = var.network.database_subnet
  }
}
