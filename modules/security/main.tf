# module "waf" {
#   source = "./waf"
#   waf_logging_s3_bucket = var.waf_logging_s3_bucket
# }

# module "certificate"{
#   source = "certificate"
# }

module "kms" {
  source = "./kms"
}

module "secret" {
  source = "./secret"
}
