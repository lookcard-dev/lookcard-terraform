module "waf" {
  source = "./waf"
  waf_logging_s3_bucket = var.waf_logging_s3_bucket
}