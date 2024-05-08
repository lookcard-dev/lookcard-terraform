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

