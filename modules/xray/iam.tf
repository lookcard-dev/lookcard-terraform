resource "aws_iam_role" "cw_canary_role" {
  name = "CloudWatchSyntheticsCanariesRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "cw_canary_policy" {
  name   = "cw_canary_policy"
  role   = aws_iam_role.cw_canary_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject"
        ],
        Resource = [
          "arn:aws:s3:::${var.s3_bucket}/canary/ap-southeast-1/lookcard-tron/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetBucketLocation"
        ],
        Resource = [
          "arn:aws:s3:::${var.s3_bucket}"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup"
        ],
        Resource = [
          "arn:aws:logs:ap-southeast-1:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/cwsyn-cloudwatchsyn-tron-*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:ListAllMyBuckets",
          "xray:PutTraceSegments"
        ],
        Resource = [
          "*"
        ]
      },
      {
        Effect = "Allow",
        Action = "cloudwatch:PutMetricData",
        Resource = "*",
        Condition = {
          "StringEquals": {
            "cloudwatch:namespace": "CloudWatchSynthetics"
          }
        }
      }
    ]
  })
}
