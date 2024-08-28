resource "aws_iam_role" "transaction_listener_task_exec_role" {
  name = "Transaction-Listener-Task-Execution-Role"
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

resource "aws_iam_role_policy_attachment" "transaction_listener_ecstaskexecrolepolicy_attachment" {
  role       = aws_iam_role.transaction_listener_task_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "transaction_listener_env_secrets_manager_read_policy" {
  name        = "TransactionListenerSecretsReadOnlyPolicy"
  description = "Allows read-only access to Secret - TRON"
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
          "${var.secret_manager.trongrid_secret_arn}"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "transaction_listener_secrets_manager_read_attachment" {
  role       = aws_iam_role.transaction_listener_task_exec_role.name
  policy_arn = aws_iam_policy.transaction_listener_env_secrets_manager_read_policy.arn
}

resource "aws_iam_role" "transaction_listener_task_role" {
  name = "Transaction-Listener-Task-Role"
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

resource "aws_iam_policy" "transaction_listener_ddb_policy" {
  name        = "Transaction-Listener-ReadWriteDDB"
  description = "Allows read-only access to Secret - TRONGRID"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:*"
        ],
        "Resource" : [
          var.dynamodb_crypto_transaction_listener_arn
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "transaction_listener_sqs_send_message_policy" {
  name        = "SQSSendMessagePolicy"
  description = "Allows sending messages to a specific SQS queue"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:SendMessage"
        ]
        Resource = "*"
        Resource = var.sqs.aggregator_tron_arn
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "transaction_listener_ddb_attachment" {
  role       = aws_iam_role.transaction_listener_task_role.name
  policy_arn = aws_iam_policy.transaction_listener_ddb_policy.arn
}

resource "aws_iam_role_policy_attachment" "transaction_listener_sqs_attachment" {
  role       = aws_iam_role.transaction_listener_task_role.name
  policy_arn = aws_iam_policy.transaction_listener_sqs_send_message_policy.arn
}