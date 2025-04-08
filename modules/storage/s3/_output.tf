output "data_bucket_arn" {
  value = aws_s3_bucket.data.arn
}

output "data_bucket_name" {
  value = aws_s3_bucket.data.bucket
}

output "log_bucket_arn" {
  value = aws_s3_bucket.log.arn
}

output "log_bucket_name" {
  value = aws_s3_bucket.log.bucket
}
