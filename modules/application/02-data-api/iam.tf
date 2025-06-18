resource "aws_iam_role" "task_execution_role" {
  name = "${var.name}-task-execution-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ECSTaskExecutionRolePolicy_attachment" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "secrets_read_only" {
  name = "SecretsReadOnlyPolicy"
  role = aws_iam_role.task_execution_role.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : [var.secret_arns["SENTRY"]]
      }
    ]
  })
}

resource "aws_iam_role" "task_role" {
  name = "${var.name}-task-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "cloudwatch_log" {
  name = "CloudWatchLogPolicy"
  role = aws_iam_role.task_role.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:DescribeLogStreams",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : [
          "${aws_cloudwatch_log_group.app_log_group.arn}:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "dynamodb_policy" {
  name = "DynamoDBPolicy"
  role = aws_iam_role.task_role.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:Query",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
        ],
        "Resource" : [
          aws_dynamodb_table.data.arn,
          aws_dynamodb_table.nonce.arn,
          "${aws_dynamodb_table.data.arn}/index/*",
          "${aws_dynamodb_table.nonce.arn}/index/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "kms_policy" {
  name = "KMSPolicy"
  role = aws_iam_role.task_role.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["kms:GenerateDataKey"],
        "Resource" : [var.kms_key_arns.data.generator]
      },
      {
        "Effect" : "Allow",
        "Action" : ["kms:Encrypt", "kms:Decrypt"],
        "Resource" : [var.kms_key_arns.data.encryption]
      }
    ]
  })
}


resource "aws_iam_role_policy" "s3_policy" {
  name = "S3Policy"
  role = aws_iam_role.task_role.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["s3:GetObject", "s3:PutObject"],
        "Resource" : [
          "arn:aws:s3:::${var.s3_bucket_names.data}",
          "arn:aws:s3:::${var.s3_bucket_names.data}/*"
        ]
      }
    ]
  })
}
