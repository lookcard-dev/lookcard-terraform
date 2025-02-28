module "cloudwatch" {
  source = "./cloudwatch"

  aws_provider        = var.aws_provider
  runtime_environment = var.runtime_environment
}
