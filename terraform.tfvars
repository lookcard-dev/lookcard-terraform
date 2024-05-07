general_config = {
  env = "testing"
}

aws_provider = {
  region     = "ap-southeast-1"
  account_id = "576293270682"
}

s3_bucket = {
  ekyc_data      = "look-card-uat-new-upload"
  alb_log        = "look-card-load-balancer-uat-new-log"
  front_end      = "uat.lookcard.io"
  cloudfront_log = "cloudfront-logs-lookcard-uat"
  vpc_flow_log   = "vpc-flow-logs-lookcard-uat"
  aml_code       = "aml-code"
}
