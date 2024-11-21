module "s3" {
  source = "./s3"
  
  s3_bucket = var.s3_bucket
  environment = var.environment
  aws_provider = var.aws_provider
}
