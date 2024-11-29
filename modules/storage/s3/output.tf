# output "alb_log" {
#   value = aws_s3_bucket.alb_log

# }
# output "cloudfront_log" {
#   value = aws_s3_bucket.cloudfront_log

# }

# output "vpc_flow_log" {
#   value = aws_s3_bucket.vpc_flow_log

# }

# output "aml_code" {
#   value = aws_s3_bucket.aml_code.bucket

# }
# output "front_end_endpoint" {
#   value = aws_s3_bucket.front_end_endpoint

# }

# output "cloudwatch_syn_canaries" {
#   value = aws_s3_bucket.cloudwatch_syn_canaries.bucket

# }
# output "accountid_data" {
#   value = aws_s3_bucket.accountid_data.bucket
# }

# output "reseller_portal_bucket" {
#   value = aws_s3_bucket.reseller_portal
# }

# output "waf_log" {
#   value = aws_s3_bucket.waf_log.arn

# }

output "lookcard_log_bucket" {
  value = {
    bucket_domain_name = aws_s3_bucket.lookcard_log.bucket_domain_name
  }
}

output "waf_log_bucket" {
  value = {
    arn = aws_s3_bucket.waf_log.arn
  }
}

output "cloudwatch_syn_canaries" {
  value = aws_s3_bucket.cloudwatch_syn_canaries.bucket
}