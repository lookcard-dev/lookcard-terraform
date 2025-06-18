module "kms" {
  source = "./kms"
}

module "secret" {
  source = "./secret"
}

module "iam" {
  source              = "./iam"
  runtime_environment = var.runtime_environment
  aws_provider        = var.aws_provider
}