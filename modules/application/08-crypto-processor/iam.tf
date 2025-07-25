resource "aws_iam_role" "lambda_function_role" {
  name = "${var.name}-lambda-function-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "AWSLambdaSQSQueueExecutionRole_attachment" {
  role       = aws_iam_role.lambda_function_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole_attachment" {
  role       = aws_iam_role.lambda_function_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "AWSXRayDaemonWriteAccess_attachment" {
  role       = aws_iam_role.lambda_function_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}

resource "aws_iam_role_policy" "cloudwatch_log" {
  name = "CloudWatchLogPolicy"
  role = aws_iam_role.lambda_function_role.id
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
          "${aws_cloudwatch_log_group.sweep_processor_app_log_group.arn}:*",
          "${aws_cloudwatch_log_group.sweep_processor_lambda_log_group.arn}:*",
          "${aws_cloudwatch_log_group.withdrawal_processor_app_log_group.arn}:*",
          "${aws_cloudwatch_log_group.withdrawal_processor_lambda_log_group.arn}:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "secrets_read_only" {
  name = "SecretsReadOnlyPolicy"
  role = aws_iam_role.lambda_function_role.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : [
          var.secret_arns["SENTRY"],
          var.secret_arns["SUMSUB"],
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "dynamodb_read_write" {
  name = "DynamoDBReadWritePolicy"
  role = aws_iam_role.lambda_function_role.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
        ],
        "Resource" : [
          aws_dynamodb_table.transaction_monitoring_result.arn
        ]
      }
    ]
  })
}

