resource "aws_s3_bucket" "waf_log" {
  bucket = "aws-waf-logs-${var.aws_provider.account_id}-lookcard"
}

resource "aws_s3_bucket" "data" {
  bucket = "${var.aws_provider.account_id}-data"
}

resource "aws_s3_bucket" "log" {
  bucket = "${var.aws_provider.account_id}-log"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "waf_log" {
  bucket = aws_s3_bucket.waf_log.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "waf_log" {
  bucket = aws_s3_bucket.waf_log.id

  rule {
    id     = "transition_to_ia_and_glacier"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    transition {
      days          = 180
      storage_class = "DEEP_ARCHIVE"
    }
  }
}

# Encryption for log bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "log" {
  bucket = aws_s3_bucket.log.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Lifecycle rule for log bucket
resource "aws_s3_bucket_lifecycle_configuration" "log" {
  bucket = aws_s3_bucket.log.id

  rule {
    id     = "log_lifecycle"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    transition {
      days          = 180
      storage_class = "DEEP_ARCHIVE"
    }
  }
}

# Encryption for data bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "data" {
  bucket = aws_s3_bucket.data.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}