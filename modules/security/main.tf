module "waf" {
  source = "./waf"
  waf_logging_s3_bucket = var.waf_logging_s3_bucket
  # reseller_api_stage = var.reseller_api_stage
}

module "certificate"{
  source = "certificate"
}