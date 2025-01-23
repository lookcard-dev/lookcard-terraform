resource "aws_s3_bucket" "lookcard_reseller_portal" {
  #bucket = "${var.aws_provider.account_id}-${var.s3_bucket.lookcard_reseller_portal}"
  bucket = "227720554629-lookcard-reseller-portal"
}

resource "aws_s3_bucket_policy" "lookcard_reseller_portal" {
  bucket = aws_s3_bucket.lookcard_reseller_portal.id
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
        "Resource" : "${aws_s3_bucket.lookcard_reseller_portal.arn}/*",
        "Condition" : {
          "StringEquals" : {
            "AWS:SourceArn" : aws_cloudfront_distribution.reseller_portal.arn
          }
        }
      }
    ]
  })
}