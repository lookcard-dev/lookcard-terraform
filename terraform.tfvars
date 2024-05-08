general_config = {
  env = "testing"
  domain = "lookcard.io"
}

aws_provider = {
  region     = "ap-southeast-1"
  account_id = "576293270682"
}

s3_bucket = {
  ekyc_data      = "lookcard-ekyc"
  alb_log        = "lookcard-alb-logging"
  cloudfront_log = "lookcard-cloudfront-logging"
  vpc_flow_log   = "lookcard-vpc-flowlog-lookcard"
  aml_code       = "lookcard-lambda-aml-code"
}




front_end_endpoint = "testing.lookcard.io"
