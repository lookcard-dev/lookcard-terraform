resource "aws_iam_role" "account_api_task_execution_role" {
  name = "Account-API-Task-Execution-Role"
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

resource "aws_iam_policy" "account_api_env_secrets_manager_read_policy" {
  name        = "AccountAPISecretsReadOnlyPolicy"
  description = "Allows read-only access to Secret - CryptoAPI-env and FIREBASE"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid"    : "secretSid",
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : local.iam_secrets
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "Account_API_ECSTaskExecutionRolePolicy_attachment" {
  role       = aws_iam_role.account_api_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "Account_API_secrets_manager_read_attachment" {
  role       = aws_iam_role.account_api_task_execution_role.name
  policy_arn = aws_iam_policy.account_api_env_secrets_manager_read_policy.arn
}

resource "aws_iam_role" "account_api_task_role" {
  name = "Account-API-Task-Role"
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

resource "aws_iam_policy" "account_api_sqs_sendmessage" {
  name        = "AccountAPI-SQSSendMessage"
  description = "Allows send message to Lookcard_Notification.fifo SQS Queue"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sqs:SendMessage"
        ],
        "Resource" : [
          "${var.sqs.lookcard_notification_queue_arn}",
          "${var.sqs.crypto_fund_withdrawal_queue_arn}"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "Account_API_SQS_SendMessage_attachment" {
  role       = aws_iam_role.account_api_task_role.name
  policy_arn = aws_iam_policy.account_api_sqs_sendmessage.arn
}


resource "aws_iam_policy" "account_api_cloudwatch_putlog_policy" {
  name        = "AccountAPICloudWatchPutLogPolicy"
  description = "Allows account-api put log to log group /lookcard/account-api"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
            "logs:DescribeLogStreams",
            "logs:PutLogEvents"
        ],
        "Resource" : [
            "${aws_cloudwatch_log_group.application_log_group_account_api.arn}:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "account_api_cloudwatch_putlog_attachment" {
  role      = aws_iam_role.account_api_task_role.name
  policy_arn = aws_iam_policy.account_api_cloudwatch_putlog_policy.arn
}