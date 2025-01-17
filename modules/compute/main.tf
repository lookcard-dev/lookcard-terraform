module "ecs" {
  source = "./ecs"

  aws_provider        = var.aws_provider
  runtime_environment = var.runtime_environment
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids
}