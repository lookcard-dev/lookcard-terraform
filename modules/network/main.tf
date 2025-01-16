module "vpc" {
  source = "./vpc"
  network = var.network
  aws_provider = var.aws_provider
}
