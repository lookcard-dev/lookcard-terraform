# variable "reseller_api_stage" {}
variable "waf_logging_s3_bucket" {}

provider "aws" {
  region = "ap-southeast-1"
}

provider "aws" {
  region = "us-east-1"
  alias = "us_east_1"
}