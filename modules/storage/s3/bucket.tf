
resource "aws_s3_bucket" "cloudwatch_syn_canaries" {
  bucket = var.s3_bucket.cloudwatch_syn_canaries
}

resource "aws_s3_bucket" "waf_log" {
  bucket = var.s3_bucket.waf_log
}

resource "aws_s3_bucket" "lookcard_download" {
  bucket = "${var.aws_provider.account_id}-${var.s3_bucket.lookcard_download}"
}

resource "aws_s3_bucket" "lookcard_metadata" {
  bucket = "${var.aws_provider.account_id}-${var.s3_bucket.lookcard_metadata}"
}

resource "aws_s3_bucket" "lookcard_log" {
  bucket = "${var.aws_provider.account_id}-${var.s3_bucket.lookcard_log}"
}

resource "aws_s3_bucket" "lookcard_corporate_portal" {
  bucket = "${var.aws_provider.account_id}-${var.s3_bucket.lookcard_corporate_portal}"
}

resource "aws_s3_bucket" "lookcard_verification_portal" {
  bucket = "${var.aws_provider.account_id}-${var.s3_bucket.lookcard_verification_portal}"
}

resource "aws_s3_bucket" "lookcard_reseller_portal" {
  bucket = "${var.aws_provider.account_id}-${var.s3_bucket.lookcard_reseller_portal}"
}

resource "aws_s3_bucket" "lookcard_merchant_portal" {
  bucket = "${var.aws_provider.account_id}-${var.s3_bucket.lookcard_merchant_portal}"
}

  resource "aws_s3_bucket" "lookcard_admin_console" {
  bucket = "${var.aws_provider.account_id}-${var.s3_bucket.lookcard_admin_console}"
}
