resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "AWSConsole-AccessLogs-Policy-1633169248226",
    "Statement" : [
      {
        "Sid" : "AWSConsoleStmt-1633169248226",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::114774131450:root"
        },
        "Action" : "s3:PutObject",
        "Resource" : "${aws_s3_bucket.alb_log.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
      },
      {
        "Sid" : "AWSLogDeliveryWrite",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "delivery.logs.amazonaws.com"
        },
        "Action" : "s3:PutObject",
        "Resource" : "${aws_s3_bucket.alb_log.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
        "Condition" : {
          "StringEquals" : {
            "s3:x-amz-acl" : "bucket-owner-full-control"
          }
        }
      },
      {
        "Sid" : "AWSLogDeliveryAclCheck",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "delivery.logs.amazonaws.com"
        },
        "Action" : "s3:GetBucketAcl",
        "Resource" : "${aws_s3_bucket.alb_log.arn}"
      }
    ]
  })
}

resource "aws_s3_bucket_ownership_controls" "cloudfront_log_ownership" {
  bucket = aws_s3_bucket.cloudfront_log.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_acl" "cdn_log_acl" {
  bucket = aws_s3_bucket.cloudfront_log.id
  acl    = "private"
}
resource "aws_s3_bucket_policy" "vpc_log_s3_policy" {
  bucket = aws_s3_bucket.vpc_flow_log.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AWSLogDeliveryWrite",
        Effect = "Allow",
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        },
        Action   = "s3:PutObject",
        Resource = "${aws_s3_bucket.vpc_flow_log.arn}/*",
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id,
            "s3:x-amz-acl"      = "bucket-owner-full-control"
          },
          ArnLike = {
            "aws:SourceArn" = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
          }
        }
      },
      {
        Sid    = "AWSLogDeliveryAclCheck",
        Effect = "Allow",
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        },
        Action = [
          "s3:GetBucketAcl",
          "s3:ListBucket"
        ],
        Resource = aws_s3_bucket.vpc_flow_log.arn,
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          },
          ArnLike = {
            "aws:SourceArn" = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_policy" "lookcard_log" {
  bucket = aws_s3_bucket.lookcard_log.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::114774131450:root"
        },
        "Action" : "s3:PutObject",
        "Resource" : [
          "${aws_s3_bucket.lookcard_log.arn}/ELB/lookcard/connection_logs/*",
          "${aws_s3_bucket.lookcard_log.arn}/ELB/lookcard/access_logs/*"
        ]
      }
    ]
  })
}

resource "aws_s3_bucket_policy" "reseller_portal" {
  bucket = aws_s3_bucket.reseller_portal.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "PolicyForCloudFrontPrivateContent",
    "Statement" : [
      {
        "Sid" : "AllowCloudFrontServicePrincipalReadOnly",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com"
        },
        "Action" : "s3:GetObject",
        "Resource" : "${aws_s3_bucket.reseller_portal.arn}/*",
        "Condition" : {
          "StringEquals" : {
            "AWS:SourceArn" : var.cloudfront.reseller_portal.arn
          }
        }
      }
    ]
  })
}
