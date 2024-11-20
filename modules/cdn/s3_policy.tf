provider "aws" {
  alias  = "origin_s3_bucket"
  region = "ap-southeast-1" # replace with the region where your S3 bucket is located
}

# resource "aws_s3_bucket_policy" "cloudfront-bucket-policy" {
#   provider = aws.origin_s3_bucket
#   bucket   = var.origin_s3_bucket.id
#   policy = jsonencode({
#     "Version" : "2008-10-17",
#     "Id" : "Policy1357935677554",
#     "Statement" : [
#       {
#         "Sid" : "Stmt1357935647218",
#         "Effect" : "Allow",
#         "Principal" : {
#           "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/GitHubAction-AssumeRoleWithAction"
#         },
#         "Action" : "s3:ListBucket",
#         "Resource" : var.origin_s3_bucket.arn
#       },
#       {
#         "Sid" : "Stmt1357935676138",
#         "Effect" : "Allow",
#         "Principal" : {
#           "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/GitHubAction-AssumeRoleWithAction"
#         },
#         "Action" : [
#           "s3:PutObject",
#           "s3:DeleteObject"
#         ],
#         "Resource" : "${var.origin_s3_bucket.arn}/*"
#       },
#       {
#         "Sid" : "AllowCloudFrontServicePrincipal",
#         "Effect" : "Allow",
#         "Principal" : {
#           "Service" : "cloudfront.amazonaws.com"
#         },
#         "Action" : "s3:GetObject",
#         "Resource" : "${var.origin_s3_bucket.arn}/*",
#         "Condition" : {
#           "StringEquals" : {
#             "AWS:SourceArn" : "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.look-card-cdn.id}"
#           }
#         }
#       }
#     ]
#   })
# }
