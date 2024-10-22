resource "aws_iam_role" "config_api_task_execution_role" {
  name = "config_api_task_execution_role"
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

resource "aws_iam_role_policy_attachment" "Crypto_API_ECSTaskExecutionRolePolicy_attachment" {
  role       = aws_iam_role.config_api_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "config_api_task_role" {
  name = "config-api-task-role"
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

  tags = {}
}

resource "aws_iam_policy" "config_api_dynamodb_read_write_policy" {
  name        = "ConfigAPIDynamoDbReadWritePolicy"
  description = "Allows read-write access to DynamoDB resources"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:UpdateItem"
        ],
        "Resource" : var.dynamodb_config_api_config_data_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ConfigAPI_dynamodb_attachment" {
  role       = aws_iam_role.config_api_task_execution_role.name
  policy_arn = aws_iam_policy.config_api_dynamodb_read_write_policy.arn
}

resource "aws_iam_policy" "config_api_logging_policy" {
  name        = "ConfigAPILoggingPolicy"
  description = "Allows logging stream"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ],
        "Resource" : "${aws_cloudwatch_log_group.application_log_group_config_api.arn}:*"
      }
    ]
  })
}

resource "aws_iam_policy" "config_api_logging_full_policy" {
  name        = "ConfigAPILoggingFullPolicy"
  description = "Allows full access to logging streams"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ],
        "Resource" : "${aws_cloudwatch_log_group.application_log_group_config_api.arn}:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ConfigAPI_logging_attachment" {
  role       = aws_iam_role.config_api_task_execution_role.name
  policy_arn = aws_iam_policy.config_api_logging_policy.arn
}

resource "aws_iam_role_policy_attachment" "ConfigAPI_logging_task_attachment" {
  role       = aws_iam_role.config_api_task_role.name
  policy_arn = aws_iam_policy.config_api_logging_policy.arn
}

resource "aws_iam_role_policy_attachment" "ConfigAPI_logging_task_full_attachment" {
  role       = aws_iam_role.config_api_task_role.name
  policy_arn = aws_iam_policy.config_api_logging_full_policy.arn
}

resource "aws_iam_policy" "secrets_manager_policy" {
  name        = "SecretsManagerPolicy"
  description = "Policy to allow access to specific secrets in Secrets Manager"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource": [
          "*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ConfigAPI_secrets_manager_attachment" {
  role       = aws_iam_role.config_api_task_execution_role.name
  policy_arn = aws_iam_policy.secrets_manager_policy.arn
}

resource "aws_iam_policy" "config_api_cloudwatch_putlog_policy" {
  name        = "ConfigAPICloudWatchPutLogPolicy"
  description = "Allows config-api put log to log group /lookcard/config-api"
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
            "${aws_cloudwatch_log_group.application_log_group_config_api.arn}:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "config_api_cloudwatch_putlog_attachment" {
  role      = aws_iam_role.config_api_task_role.name
  policy_arn = aws_iam_policy.config_api_cloudwatch_putlog_policy.arn
}