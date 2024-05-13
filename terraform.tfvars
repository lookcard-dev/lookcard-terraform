general_config = {
  env    = "testing"
  domain = "test.lookcard.io"
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

network = {
  vpc_cidr                  = "10.0.0.0/16"
  public_subnet_cidr_list   = ["10.0.24.0/23", "10.0.26.0/23", "10.0.28.0/23"]
  private_subnet_cidr_list  = ["10.0.0.0/21", "10.0.8.0/21", "10.0.16.0/21"]
  database_subnet_cidr_list = ["10.0.36.0/24", "10.0.37.0/24", "10.0.38.0/24"]
  isolated_subnet_cidr_list = ["10.0.30.0/23", "10.0.32.0/23", "10.0.34.0/23"]
}

front_end_endpoint = "testing.lookcard.io"

dns_config = {
  host_name       = "app"
  api_host_name   = "api"
  admin_host_name = "admin"
}
