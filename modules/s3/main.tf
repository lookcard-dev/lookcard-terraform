# resource "aws_s3_bucket" "look-card" {
#   bucket = var.bucket_name
# }

# resource "aws_s3_bucket" "aml_code" {
#   bucket = var.aml_code
# }


# resource "aws_s3_bucket" "static_website_bucket" {
#   bucket = var.static_website_bucket
# }


# resource "aws_s3_bucket" "application_loadbalancer_log" {
#   bucket = var.bucket_alb
# }


# data "aws_caller_identity" "current" {}

# locals {
#     account_id = data.aws_caller_identity.current.account_id
# }

# resource "aws_s3_bucket_policy" "alb_log" {
#   bucket = aws_s3_bucket.application_loadbalancer_log.id
#   policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Id" : "AWSConsole-AccessLogs-Policy-1633169248226",
#     "Statement" : [
#       {
#         "Sid" : "AWSConsoleStmt-1633169248226",
#         "Effect" : "Allow",
#         "Principal" : {
#           "AWS" : "arn:aws:iam::114774131450:root"
#         },
#         "Action" : "s3:PutObject",
#         "Resource" : "${aws_s3_bucket.application_loadbalancer_log.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
#       },
#       {
#         "Sid" : "AWSLogDeliveryWrite",
#         "Effect" : "Allow",
#         "Principal" : {
#           "Service" : "delivery.logs.amazonaws.com"
#         },
#         "Action" : "s3:PutObject",
#         "Resource" : "${aws_s3_bucket.application_loadbalancer_log.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
#         "Condition" : {
#           "StringEquals" : {
#             "s3:x-amz-acl" : "bucket-owner-full-control"
#           }
#         }
#       },
#       {
#         "Sid" : "AWSLogDeliveryAclCheck",
#         "Effect" : "Allow",
#         "Principal" : {
#           "Service" : "delivery.logs.amazonaws.com"
#         },
#         "Action" : "s3:GetBucketAcl",
#         "Resource" : "${aws_s3_bucket.application_loadbalancer_log.arn}"
#       }
#     ]
#   })
# }


# resource "aws_kms_key" "s3" {
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "kms_upload_s3" {
#   bucket = aws_s3_bucket.look-card.bucket
#   rule {
#     apply_server_side_encryption_by_default {
#       kms_master_key_id = aws_kms_key.s3.arn
#       sse_algorithm     = "aws:kms:dsse"
#     }
#   }

# }


# resource "aws_s3_bucket_policy" "upload_UAT" {
#   bucket = aws_s3_bucket.look-card.id
#   policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Sid" : "Look-Card-Upload-UAT",
#         "Effect" : "Allow",
#         "Principal" : {
#           "AWS" : "${var.ecsrole}"
#         },
#         "Action" : [
#           "s3:PutObject",
#           "s3:GetObject",
#           "s3:GetObjectVersion",
#           "s3:DeleteObject",
#           "s3:DeleteObjectVersion",
#           "s3:ListBucket"
#         ],
#         "Resource" : [
#           "${aws_s3_bucket.look-card.arn}",
#           "${aws_s3_bucket.look-card.arn}/*"
#         ]
#       }
#     ]
#   })
# }