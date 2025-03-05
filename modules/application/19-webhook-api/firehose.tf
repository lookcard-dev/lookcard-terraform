
resource "aws_kinesis_firehose_delivery_stream" "sumsub_webhook" {
  name        = "sumsub-webhook"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn            = aws_iam_role.firehose_role.arn
    bucket_arn          = data.aws_s3_bucket.log_bucket.arn
    compression_format  = "GZIP"
    prefix              = "webhook/sumsub/!{timestamp:yyyy/MM/dd}/"
    error_output_prefix = "webhook/sumsub/error/!{firehose:error-output-type}/!{timestamp:yyyy/MM/dd}/"
    buffering_interval  = 60
    buffering_size      = 5
    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/webhook/sumsub"
      log_stream_name = "S3Delivery"
    }
  }

  server_side_encryption {
    enabled = true
  }
}

resource "aws_kinesis_firehose_delivery_stream" "reap_webhook" {
  name        = "reap-webhook"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn            = aws_iam_role.firehose_role.arn
    bucket_arn          = data.aws_s3_bucket.log_bucket.arn
    compression_format  = "GZIP"
    prefix              = "webhook/reap/!{timestamp:yyyy/MM/dd}/"
    error_output_prefix = "webhook/reap/error/!{firehose:error-output-type}/!{timestamp:yyyy/MM/dd}/"
    buffering_interval  = 60
    buffering_size      = 5
    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/webhook/reap"
      log_stream_name = "S3Delivery"
    }
  }

  server_side_encryption {
    enabled = true
  }
}

resource "aws_kinesis_firehose_delivery_stream" "firebase_webhook" {
  name        = "firebase-webhook"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn            = aws_iam_role.firehose_role.arn
    bucket_arn          = data.aws_s3_bucket.log_bucket.arn
    compression_format  = "GZIP"
    prefix              = "webhook/firebase/!{timestamp:yyyy/MM/dd}/"
    error_output_prefix = "webhook/firebase/error/!{firehose:error-output-type}/!{timestamp:yyyy/MM/dd}/"
    buffering_interval  = 60
    buffering_size      = 5
    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/webhook"
      log_stream_name = "S3Delivery"
    }
  }

  server_side_encryption {
    enabled = true
  }
}
