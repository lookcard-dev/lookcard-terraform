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
