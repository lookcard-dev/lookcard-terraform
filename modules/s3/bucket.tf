resource "aws_s3_bucket" "ekyc_data" {
  bucket = "${var.ekyc_data}-${var.environment}"
}

resource "aws_s3_bucket" "alb_log" {
  bucket = "${var.alb_log}-${var.environment}"
}

resource "aws_s3_bucket" "cloudfront_log" {
  bucket = "${var.cloudfront_log}-${var.environment}"
}

resource "aws_s3_bucket" "vpc_flow_log" {
  bucket = "${var.vpc_flow_log}-${var.environment}"
}

resource "aws_s3_bucket" "aml_code" {
  bucket = "${var.aml_code}-${var.environment}"
}

resource "aws_s3_bucket" "front_end_endpoint" {
  bucket = var.front_end_endpoint
}

resource "aws_s3_bucket" "cloudwatch_syn_canaries" {
  bucket = var.cloudwatch_syn_canaries
}
resource "aws_s3_bucket" "accountid_data" {
  bucket = var.accountid_data
}
resource "aws_s3_bucket" "lookcard_log" {
  bucket = var.lookcard_log
}

resource "aws_s3_bucket" "reseller_portal" {
  bucket = var.reseller_portal
}

resource "aws_s3_bucket" "waf_log" {
  bucket = var.waf_log
}