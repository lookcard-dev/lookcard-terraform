data "aws_caller_identity" "current" {}
variable "environment" {}

variable "ekyc_data" {}
variable "alb_log" {}
variable "cloudfront_log" {}
variable "vpc_flow_log" {}
variable "aml_code" {}
variable "front_end_endpoint" {}
