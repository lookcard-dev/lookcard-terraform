data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

variable "environment" {}
variable "ekyc_data" {}
variable "alb_log" {}
variable "cloudfront_log" {}
variable "vpc_flow_log" {}
variable "aml_code" {}
variable "front_end_endpoint" {}
variable "cloudwatch_syn_canaries" {}
variable "accountid_data" {}
variable "lookcard_log" {}
variable "reseller_portal" {}
# variable "cloudfront" {}
variable "waf_log" {}

















