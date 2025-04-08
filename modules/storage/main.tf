module "s3" {
  source              = "./s3"
  runtime_environment = var.runtime_environment
  aws_provider        = var.aws_provider
}

module "datacache" {
  source              = "./datacache"
  aws_provider        = var.aws_provider
  runtime_environment = var.runtime_environment
  vpc_id              = var.vpc_id
  subnet_ids          = var.subnet_ids.datacache
  external_security_group_ids = var.external_security_group_ids
}

module "datastore" {
  source              = "./datastore"
  aws_provider        = var.aws_provider
  runtime_environment = var.runtime_environment
  vpc_id              = var.vpc_id
  subnet_ids          = var.subnet_ids.datastore
  external_security_group_ids = var.external_security_group_ids
  secret_arns = var.secret_arns
}

module "ecr" {
  source     = "./ecr"
  components = var.components
}
